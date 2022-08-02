//
//  PhotoCardController.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.06.22.
//

import UIKit
import FirebaseFirestore
import JGProgressHUD

class PhotoCardController: UIViewController {
    
    // MARK: - Private properties

    private lazy var topButtonsStackView = TopNavigationStackView()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bottomButtonsStackView = BottomButtonsControlsStackView()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topButtonsStackView,
                                                       backgroundView,
                                                       bottomButtonsStackView])
        stackView.axis = .vertical
        return stackView
    }()
    
//    private let photoViewModel: [PhotoCardViewModel] = {
//        let producers = [
//            User(name: "Alex",
//                 age: 28,
//                 profession: "Tik-Tok model",
//                 imagesUrl: Constants.Photo.girl6) ,
//            User(name: "Marta",
//                 age: 25,
//                 profession: "Bloger",
//                 imagesUrl: Constants.Photo.girl5) ,
//            User(name: "Nicole",
//                 age: 24,
//                 profession: "Teacher",
//                 imagesUrl: Constants.Photo.girl1) ,
//            Advertiser(brandName: "State of Survival",
//                       title: "Play Now",
//                       posterName: Constants.Photo.advertisement) ,
//            User(name: "Kim",
//                 age: 34,
//                 profession: "CEO",
//                 imagesUrl: Constants.Photo.girl2) ,
//            User(name: "Aisha",
//                 age: 30,
//                 profession: "Front-end Developer",
//                 imagesUrl: Constants.Photo.girl3) ,
//            User(name: "Anna",
//                 age: 26,
//                 profession: "Fashion model",
//                 imagesUrl: Constants.Photo.girl4)
//        ] as [ProducesPhotoCardViewModel]
//        let viewModels = producers.map({return $0.getPhotoViewModel()})
//        return viewModels
//    }()
    
    private var lastFetchedUser: User?
    
    private lazy var viewModel = [PhotoCardViewModel]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViewsLayout()
        setupViewModel()
        addAllTargets()
        fetchUsersFromFirebase()
    }
    
    // MARK: - Private Methods
    
    private func addAllTargets() {
        topButtonsStackView.settingsButton.addTarget(self,
                                                     action: #selector(didTapSettingButton),
                                                     for: .touchUpInside)
        bottomButtonsStackView.refreshButton.addTarget(self,
                                                       action: #selector(didTapRefreshButton),
                                                       for: .touchUpInside)
        bottomButtonsStackView.likeButton.addTarget(self,
                                                    action: #selector(didTapLikeButton),
                                                    for: .touchUpInside)
        bottomButtonsStackView.superLikeButton.addTarget(self,
                                                         action: #selector(didTapSuperlikeButton),
                                                         for: .touchUpInside)
        bottomButtonsStackView.thunderButton.addTarget(self,
                                                       action: #selector(didTapThunderButton),
                                                       for: .touchUpInside)
        bottomButtonsStackView.dislikeButton.addTarget(self,
                                                       action: #selector(didTapDislikeButton),
                                                       for: .touchUpInside)
    }
    
    private func setupStackViewsLayout() {
        view.addSubview(mainStackView)
        view.backgroundColor = .white
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
        mainStackView.bringSubviewToFront(backgroundView)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 5,
                                            bottom: 0, right: 5)
    }
    
    private func setupViewModel() {
        viewModel.forEach { (viewModel) in
            let photoDeckView: UIView = {
                let view = PhotoView(frame: .zero)
                view.viewModel = viewModel
                return view
            }()
            backgroundView.addSubview(photoDeckView)
            photoDeckView.fillSuperview()
        }
    }
    
    private func setupViewModel(user: User) {
        let view = PhotoView(frame: .zero)
        view.viewModel = user.getPhotoViewModel()
        backgroundView.addSubview(view)
        backgroundView.sendSubviewToBack(view)
        view.fillSuperview()
    }

    private func fetchUsersFromFirebase() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view, animated: true)
        let query = Firestore.firestore()
            .collection("users")
            .order(by: "uid")
            .start(after: [lastFetchedUser?.uid ?? ""])
            .limit(to: 2)
        query.getDocuments { [weak self] (snapshot, error) in
            hud.dismiss(animated: true)
            if let error = error {
                print(error)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let usersData = documentSnapshot.data()
                let user = User(dictionary: usersData)
                self?.viewModel.append(user.getPhotoViewModel())
                self?.lastFetchedUser = user
                self?.setupViewModel(user: user)
            })
//            self?.setupViewModel()
        }
    }
    
    // MARK: - Objc Methods

    @objc func didTapSettingButton() {
        let settingsVC = SettingsController()
        let navigationVC = UINavigationController(rootViewController: settingsVC)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
    @objc func didTapRefreshButton() {
        fetchUsersFromFirebase()
    }
    
    @objc func didTapLikeButton() {

    }
    
    @objc func didTapSuperlikeButton() {

    }
    
    @objc func didTapThunderButton() {

    }
    
    @objc func didTapDislikeButton() {

    }
}

