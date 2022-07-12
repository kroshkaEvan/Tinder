//
//  HomeController.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.06.22.
//

import UIKit

class HomeController: UIViewController {
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
    
    private let photoViewModel: [PhotoViewModel] = {
        let producers = [
            User(name: "Alex", age: 28,
                 profession: "Tik-Tok model", imagesString: Constants.Photo.girl6) ,
            User(name: "Marta", age: 25,
                 profession: "Bloger", imagesString: Constants.Photo.girl5) ,
            User(name: "Nicole", age: 24,
                 profession: "Teacher", imagesString: Constants.Photo.girl1) ,
            Advertiser(brandName: "State of Survival", title: "Play Now", posterName: Constants.Photo.advertisement) ,
            User(name: "Kim", age: 34,
                 profession: "CEO", imagesString: Constants.Photo.girl2) ,
            User(name: "Aisha", age: 30,
                 profession: "Front-end Developer", imagesString: Constants.Photo.girl3) ,
            User(name: "Anna", age: 26,
                 profession: "Fashion model", imagesString: Constants.Photo.girl4)
        ] as [ProducesPhotoViewModel]
        let viewModels = producers.map({return $0.getPhotoViewModel()})
        return viewModels
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        topButtonsStackView.settingsButton.addTarget(self,
                                                     action: #selector(didTapSettingButton),
                                                     for: .touchUpInside)
        setupStackViewsLayout()
        setupPhotoDeckLayout()
    }
    
    private func setupStackViewsLayout() {
        view.addSubview(mainStackView)
        view.backgroundColor = .systemBackground
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
        mainStackView.bringSubviewToFront(backgroundView)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 5,
                                            bottom: 0, right: 5)
    }
    
    private func setupPhotoDeckLayout() {
        photoViewModel.forEach { (photoViewModel) in
            lazy var photoDeckView: UIView = {
                let view = PhotoView(frame: .zero)
                view.viewModel = photoViewModel
                return view
            }()
            backgroundView.addSubview(photoDeckView)
            photoDeckView.fillSuperview()
        }
    }
    
    @objc func didTapSettingButton() {
        let registrVC = RegistrationController()
        registrVC.modalPresentationStyle = .fullScreen
        present(registrVC, animated: true)
    }
}

