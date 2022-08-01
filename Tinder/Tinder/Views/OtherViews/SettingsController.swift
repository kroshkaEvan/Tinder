//
//  SettingsController.swift
//  Tinder
//
//  Created by Эван Крошкин on 31.07.22.
//

import UIKit

class SettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        addAllTargets()
    }
    
    private func setupLayout() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }
    
    private func addAllTargets() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save",
                            style: .plain,
                            target: self,
                            action: #selector(didTapSave)),
            UIBarButtonItem(title: "Logout",
                            style: .plain,
                            target: self,
                            action: #selector(didTapLogout))
        ]
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSave() {
        dismiss(animated: true)
    }
    
    @objc private func didTapLogout() {
        dismiss(animated: true)
    }

}
