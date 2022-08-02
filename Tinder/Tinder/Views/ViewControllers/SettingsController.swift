//
//  SettingsController.swift
//  Tinder
//
//  Created by Эван Крошкин on 31.07.22.
//

import UIKit

class SettingsController: UITableViewController {
    
    // MARK: - Private properties
    
    private lazy var firstButtonsStackView = SelectPhotoButtonsStackView()
    
    private lazy var secondButtonsStackView = SelectPhotoButtonsStackView()
    
    private lazy var mainButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstButtonsStackView, secondButtonsStackView])
        firstButtonsStackView.anchor(top: stackView.topAnchor, leading: stackView.leadingAnchor,
                                     bottom: secondButtonsStackView.topAnchor, trailing: stackView.trailingAnchor)
        secondButtonsStackView.anchor(top: nil, leading: stackView.leadingAnchor,
                                      bottom: stackView.bottomAnchor, trailing: stackView.trailingAnchor)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        addAllTargets()
    }
    
    // MARK: - Initializers
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = view.frame.size.width * 0.85
        return height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .lightGray
        [mainButtonsStackView].forEach { header.addSubview($0) }
        mainButtonsStackView.anchor(top: header.topAnchor, leading: header.leadingAnchor,
                                    bottom: header.bottomAnchor, trailing: header.trailingAnchor,
                                    padding: .init(top: 5, left: 5,
                                                   bottom: 5, right: 5))
        return header
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }
    
    private func addAllTargets() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBack))
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
    
    // MARK: - Objc Methods
    
    @objc private func didTapBack() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSave() {
        dismiss(animated: true)
    }
    
    @objc private func didTapLogout() {
        dismiss(animated: true)
    }

}
