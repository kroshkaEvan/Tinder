//
//  DetailSettingsViewController.swift
//  Tinder
//
//  Created by Эван Крошкин on 3.08.22.
//

import UIKit

class DetailSettingsViewController: UIViewController {
    
    lazy var textField: RegistrationTextField = {
        let textField = RegistrationTextField(padding: 24,
                                              height: 50)
        textField.font = .systemFont(ofSize: 35,
                                     weight: .semibold)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
    }
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.rightBarButtonItem?.tintColor = .white
//        UIBarButtonItem(title: "Save",
//                                                            style: .plain,
//                                                            target: self,
//                                                            action: #selector(didTapSave))
    }
    
    @objc private func didTapSave() {
        dismiss(animated: true)
    }

}
