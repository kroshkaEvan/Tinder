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
    
//    private lazy var photoDeckView: UIView = {
//        let view = PhotoView(frame: .zero)
//        return view
//    }()
    
    private let users = [
        User(name: "Kim", age: 40,
             professional: "Fashion model", image: Constants.Photo.girl4) ,
        User(name: "Nicole", age: 19,
             professional: "Teacher", image: Constants.Photo.girl1) ,
        User(name: "Anna", age: 22,
             professional: "Driver", image: Constants.Photo.girl2) ,
        User(name: "Nasty", age: 25,
             professional: "Developer", image: Constants.Photo.girl3)]

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
        (users).forEach { (user) in
            lazy var photoDeckView: UIView = {
                let view = PhotoView(frame: .zero)
                view.imageView.image = user.image
                return view
            }()
            backgroundView.addSubview(photoDeckView)
            photoDeckView.fillSuperview()
        }
    }
}

