//
//  ViewController.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.06.22.
//

import UIKit

class ViewController: UIViewController {
    private lazy var topButtonsStackView = TopNavigationStackView()
    
    private lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var bottomButtonsStackView = BottomButtonsControlsStackView()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topButtonsStackView, blueView, bottomButtonsStackView])
        stackView.axis = .vertical
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViewsLayout()
    }
    
    private func setupStackViewsLayout() {
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor)
    }


}

