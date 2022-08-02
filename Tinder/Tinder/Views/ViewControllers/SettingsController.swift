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
        header.backgroundColor = .lightGray.withAlphaComponent(0.15)
        [mainButtonsStackView].forEach { header.addSubview($0) }
        let padding = CGFloat(5)
        mainButtonsStackView.anchor(top: header.topAnchor, leading: header.leadingAnchor,
                                    bottom: header.bottomAnchor, trailing: header.trailingAnchor,
                                    padding: .init(top: padding, left: padding,
                                                   bottom: padding, right: padding))
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
        [firstButtonsStackView.firstSelectPhotoButton,
         firstButtonsStackView.secondSelectPhotoButton,
         firstButtonsStackView.thirdSelectPhotoButton,
         secondButtonsStackView.firstSelectPhotoButton,
         secondButtonsStackView.secondSelectPhotoButton,
         secondButtonsStackView.thirdSelectPhotoButton].forEach { [weak self] selectButton in
            selectButton.addTarget(self,
                                   action: #selector(didTapSelectPhoto),
                                   for: .touchUpInside)
        }
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
    
    @objc private func didTapSelectPhoto(button: UIButton) {
        let imagePicker = SettingsImagePicker()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto = info[.originalImage] as? UIImage else {return}
        let imageButton = (picker as? SettingsImagePicker)?.imageButton
        imageButton?.setImage(selectedPhoto.withRenderingMode(.alwaysOriginal),
                                                                for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

