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
        let stackView = UIStackView(arrangedSubviews: [topButtonsStackView, backgroundView, bottomButtonsStackView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private let photoViewModel: [PhotoViewModel] = {
        let producers = [
            User(name: "Kim", age: 30,
                 profession: "Fashion model", imageString: Constants.Photo.girl4) ,
            User(name: "Nicole", age: 19,
                 profession: "Teacher", imageString: Constants.Photo.girl1) ,
            Advertiser(brandName: "State of Survival", title: "Play Now", posterName: Constants.Photo.state) ,
            User(name: "Anna", age: 22,
                 profession: "Driver", imageString: Constants.Photo.girl2) ,
            User(name: "Nasty", age: 32,
                 profession: "Developer", imageString: Constants.Photo.girl3)
        ] as [ProducesPhotoViewModel]
        let viewModels = producers.map({return $0.getPhotoViewModel()})
        return viewModels
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

