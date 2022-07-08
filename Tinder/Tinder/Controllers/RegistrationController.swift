//
//  RegistrationController.swift
//  Tinder
//
//  Created by Эван Крошкин on 8.07.22.
//

import UIKit

class RegistrationController: UIViewController {
    
    private lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo",
                        for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .bold)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
        return button
    }()
    
    private lazy var userNameTextFild: RegistrationTextField = {
        let textField = RegistrationTextField(padding: 24)
        textField.placeholder = "Enter your name"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 25
        return textField
    }()
    
    private lazy var emailAddressTextFild: RegistrationTextField = {
        let textField = RegistrationTextField(padding: 24)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 25
        return textField
    }()
    
    private lazy var passwordTextFild: RegistrationTextField = {
        let textField = RegistrationTextField(padding: 24)
        textField.placeholder = "Enter your password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 25
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("REGISTR", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton,
                                                       userNameTextFild,
                                                       emailAddressTextFild,
                                                       passwordTextFild,
                                                       registrationButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewGradientLayer()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(mainStackView)
        mainStackView.anchor(top: nil,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: 20,
                                            bottom: 0, right: 20))
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupViewGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constants.Color.topGradienApp.cgColor, Constants.Color.downGradienApp.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
}
