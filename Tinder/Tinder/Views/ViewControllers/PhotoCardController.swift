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
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bottomButtonsStackView = BottomButtonsControlsStackView()
    
    private var lastFetchedUser: User?
    
    private lazy var viewModel = [PhotoCardViewModel]()
    
    private lazy var progressHUD = JGProgressHUD(style: .dark)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        addAllTargets()
        fetchUsersFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Private Methods
    
    private func addAllTargets() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "person"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapSettingsButton))
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
    
    private func setupLayout() {
        view.addSubview(backgroundView)
        view.backgroundColor = .white
        backgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding:  .init(top: 10, left: 5,
                                              bottom: 10, right: 5))
        backgroundView.addSubview(bottomButtonsStackView)
        bottomButtonsStackView.anchor(top: nil,
                                      leading: backgroundView.leadingAnchor,
                                      bottom: backgroundView.bottomAnchor,
                                      trailing: backgroundView.trailingAnchor,
                                      padding: .init(top: 0,
                                                     left: 0,
                                                     bottom: 20,
                                                     right: 0))
    }
    
    private func setupViewModel(user: User) {
        let photoView = PhotoView(frame: .zero)
        photoView.viewModel = user.getPhotoViewModel()
        backgroundView.addSubview(photoView)
        photoView.anchor(top: backgroundView.topAnchor,
                    leading: backgroundView.leadingAnchor,
                    bottom: backgroundView.bottomAnchor,
                    trailing: backgroundView.trailingAnchor,
                    padding: .init(top: 0, left: 0,
                                   bottom: 20, right: 0))
        backgroundView.sendSubviewToBack(photoView)
    }

    private func fetchUsersFromFirebase() {
        progressHUD.textLabel.text = "Fetching users"
        progressHUD.show(in: view, animated: true)
        let query = Firestore.firestore().collection("users")
//            query.order(by: "uid")
//                .start(after: [lastFetchedUser?.uid ?? ""])
//                .limit(to: 2)
        query.getDocuments { [weak self] (snapshot, error) in
            self?.progressHUD.dismiss(animated: true)
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
        }
    }
    
    // MARK: - Objc Methods

    @objc func didTapSettingsButton() {
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

