//
//  ViewController.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var subViews = [UIColor.gray, .darkGray, .lightGray].map {
        (color) -> UIView in
        let someView = UIView()
        someView.backgroundColor = color
        return someView
    }
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return stackView
    }()
    
    private lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var bottomButtonsStackView = BottomButtonsControlsStackView()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomButtonsStackView])
        stackView.axis = .vertical
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
    }
    
    private func setupStackView() {
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
    }


}

