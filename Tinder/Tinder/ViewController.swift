//
//  ViewController.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var subViews = [UIColor.gray, UIColor.darkGray, UIColor.lightGray].map {
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
    
    private lazy var yellowView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, yellowView])
        stackView.axis = .vertical
        stackView.frame = .init(x: 0, y: 0,
                                width: 300, height: 200)
        return stackView
    }()
    
    private lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.fillSuperview()
    }


}

