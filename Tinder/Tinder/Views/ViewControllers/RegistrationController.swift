//
//  RegistrationController.swift
//  Tinder
//
//  Created by Эван Крошкин on 8.07.22.
//

import UIKit
import JGProgressHUD

class RegistrationController: UIViewController {
    
    private let viewModel = RegistrationViewModel()
    
    private lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo",
                        for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30,
                                                    weight: .bold)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        let heightButton = view.frame.size.width - 40
        button.heightAnchor.constraint(equalToConstant: heightButton).isActive = true
        return button
    }()
    
    private lazy var userNameTextField: RegistrationTextField = {
        let textField = RegistrationTextField(padding: 24)
        textField.placeholder = "Enter your name"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 25
        return textField
    }()
    
    private lazy var emailAddressTextField: RegistrationTextField = {
        let textField = RegistrationTextField(padding: 24)
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 25
        return textField
    }()
    
    private lazy var passwordTextField: RegistrationTextField = {
        let textField = RegistrationTextField(padding: 24)
        textField.placeholder = "Enter your password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 25
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.setTitle("REGISTER", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton,
                                                       userNameTextField,
                                                       emailAddressTextField,
                                                       passwordTextField,
                                                       registrationButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var loadingHUD = JGProgressHUD(style: .dark)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewGradientLayer()
        setupLayout()
        addAllTargets()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        addNotificationObservers()
        addTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
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
    
    private func setupViewModel() {
        viewModel.bindableIsFormValid.bind { [weak self] (isFormValid) in
            guard let isFormValid = isFormValid else {return}
            self?.registrationButton.isEnabled = isFormValid
            self?.registrationButton.backgroundColor = isFormValid ? Constants.Color.topGradienApp : .lightGray
            self?.registrationButton.setTitleColor(isFormValid ? .white : .gray,
                                                   for: .normal)
        }
        viewModel.bindableImage.bind { [weak self] (image) in
            self?.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal),
                                             for: .normal)
        }
        viewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            guard let view = self?.view else {return}
            if isRegistering == true {
                self?.loadingHUD.textLabel.text = "Register"
                self?.loadingHUD.show(in: view,
                                      animated: true)
            } else {
                self?.loadingHUD.dismiss(animated: true)
            }
        }
    }
    
    private func addAllTargets() {
        [userNameTextField, passwordTextField, emailAddressTextField].forEach { textField in
            textField.addTarget(self,
                                 action: #selector(didChangeText),
                                 for: .editingChanged)
        }
        registrationButton.addTarget(self,
                                     action: #selector(didTapRegister),
                                     for: .touchUpInside)
        selectPhotoButton.addTarget(self,
                                    action: #selector(didTapSelectPhoto),
                                    for: .touchUpInside)
    }
    
    private func setupViewGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constants.Color.topGradienApp.cgColor,
                                Constants.Color.downGradienApp.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getKeyboardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getKeyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func showHUDWith(error: Error) {
        loadingHUD.dismiss()
        let failedLoadingHUD = JGProgressHUD(style: .dark)
        failedLoadingHUD.textLabel.text = "Failed registration"
        failedLoadingHUD.detailTextLabel.text = error.localizedDescription
        failedLoadingHUD.show(in: self.view,
                              animated: true)
        failedLoadingHUD.dismiss(afterDelay: 5,
                                 animated: true)
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapDismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func didChangeText(field: UITextField) {
        switch field {
        case userNameTextField:
            return viewModel.userName = userNameTextField.text
        case emailAddressTextField:
            return viewModel.email = emailAddressTextField.text
        case passwordTextField:
            return viewModel.password = passwordTextField.text
        default:
            print("error")
        }
    }
    
    @objc private func didTapRegister() {
        self.didTapDismissKeyboard()
        // Authentication user email/password
        viewModel.performRegitration { [weak self] error in
            if let error = error {
                self?.showHUDWith(error: error)
                return
            }
        }
    }
    
    @objc private func didTapSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController,
                animated: true)
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

extension RegistrationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextField:
            emailAddressTextField.becomeFirstResponder()
        case emailAddressTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            self.didTapRegister()
        default:
            print("non keyboard type")
        }
        return false
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto = info[.originalImage] as? UIImage else {return}
        viewModel.bindableImage.value = selectedPhoto
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
