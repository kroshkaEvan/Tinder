//
//  ViewController.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.06.22.
//

import UIKit

class ViewController: UIViewController {
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
    
    private lazy var photoDeckView: UIView = {
        let view = PhotoView(frame: .zero)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViewsLayout()
        setupPhotoDeckLayout()
    }
    
    private func setupStackViewsLayout() {
        view.addSubview(mainStackView)
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
        backgroundView.addSubview(photoDeckView)
        photoDeckView.fillSuperview()
    }


}

