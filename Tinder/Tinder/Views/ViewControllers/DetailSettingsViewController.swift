//
//  DetailSettingsViewController.swift
//  Tinder
//
//  Created by Эван Крошкин on 3.08.22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DetailSettingsViewController: UIViewController {
    
    // MARK: - Public properties

    lazy var textField: CustomTextField = {
        let textField = CustomTextField(padding: 24,
                                              height: 50)
        textField.font = .systemFont(ofSize: 35,
                                     weight: .semibold)
        return textField
    }()
    
    var currentUser: User?
    var section: Int?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
        textField.addTarget(self,
                            action: #selector(setInfo),
                            for: .editingChanged)
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        view.backgroundColor = .lightGray
        view.addSubview(textField)
        textField.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                         bottom: nil, trailing: view.trailingAnchor,
                         padding: .init(top: 100, left: 20,
                                        bottom: 0, right: 20),
                         size: .init(width: view.frame.size.width * 0.8,
                                     height: 60))
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let documentData = ["userName" : currentUser?.name ?? "",
                            "uid" : currentUser?.uid ?? "",
                            "imagesURL" : currentUser?.imagesURL ?? "",
                            "age" : currentUser?.age ?? 18,
                            "profession" : currentUser?.profession ?? "",
                            "bio" : currentUser?.bio ?? ""] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
            if let error = error {
                print(error)
                return
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "settingsUser"),
                                            object: nil)
        }
        self.dismiss(animated: true)

    }
    
    @objc func setInfo() {
        DispatchQueue.main.async {
            switch self.section {
            case 1:
                self.currentUser?.name = self.textField.text
            case 2:
                self.currentUser?.age = Int(self.textField.text ?? "18")
            case 3:
                self.currentUser?.profession = self.textField.text
            case 4:
                self.currentUser?.bio = self.textField.text
            default:
                return
            }
        }
    }

}
