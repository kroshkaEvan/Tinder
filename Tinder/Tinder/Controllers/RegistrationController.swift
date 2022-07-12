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
        let heightButton = view.frame.size.width - 40
        button.heightAnchor.constraint(equalToConstant: heightButton).isActive = true
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
        setupNotificationObservers()
        addTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupLayout() {
        view.addSubview(mainStackView)
        let paddingStackView: CGFloat = 20
        mainStackView.anchor(top: nil,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: paddingStackView,
                                            bottom: 0, right: paddingStackView))
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupViewGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constants.Color.topGradienApp.cgColor, Constants.Color.downGradienApp.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getKeyboardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getKeyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapDismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func getKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - mainStackView.frame.origin.y - mainStackView.frame.height
        let translationY = bottomSpace - mainStackView.spacing - keyboardFrame.height
        self.view.transform = CGAffineTransform(translationX: 0,
                                                y: translationY)
    }
    
    @objc func getKeyboardHide() {
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    
    @objc func didTapDismissKeyboard() {
        self.view.endEditing(true)
    }
}
