//
//  SettingsController.swift
//  Tinder
//
//  Created by Эван Крошкин on 31.07.22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD
import SDWebImage

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
    
    private lazy var headerView: UIView = {
        let header = UIView()
        header.backgroundColor = .lightGray.withAlphaComponent(0.2)
        [mainButtonsStackView].forEach { header.addSubview($0) }
        let padding = CGFloat(5)
        mainButtonsStackView.anchor(top: header.topAnchor, leading: header.leadingAnchor,
                                    bottom: header.bottomAnchor, trailing: header.trailingAnchor,
                                    padding: .init(top: padding, left: padding,
                                                   bottom: padding, right: padding))
        return header
    }()
        
    private var currentUser: User?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addAllTargets()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "fetchSettingsUser"), object: nil)
    }
    
    // MARK: - Initializers
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = view.frame.size.width * 0.85
        if section == 0 {
            return height
        }
        return 25
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = HeaderLabel()
        headerLabel.textInsets = .init(top: 0, left: 40, bottom: 10, right: 0)
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        switch section {
        case 0:
            return headerView
        case 1:
            headerLabel.text = "Name"
            return headerLabel
        case 2:
            headerLabel.text = "Age"
            return headerLabel
        case 3:
            headerLabel.text = "Profession"
            return headerLabel
        default:
            headerLabel.text = "Bio"
            return headerLabel
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default,
                                reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter name"
            cell.textField.text = currentUser?.name
        case 2:
            cell.textField.placeholder = "Enter age"
            if let age = currentUser?.age {
                cell.textField.text = String(age)
            }
        case 3:
            cell.textField.placeholder = "Enter profession"
            cell.textField.text = currentUser?.profession
        case 4:
            cell.textField.placeholder = "Enter bio"
            cell.textField.text = currentUser?.bio
        default:
            cell.textField.placeholder = "Enter bio"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailSettingsViewController()
        let navigationVc = UINavigationController(rootViewController: detailVC)
        if let sheet = navigationVc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        let section = indexPath.section
        switch section {
        case 1:
            detailVC.textField.placeholder = "Enter name"
            detailVC.textField.text = currentUser?.name
        case 2:
            detailVC.textField.placeholder = "Enter age"
            if let age = currentUser?.age {
                detailVC.textField.text = String(age)
            }
        case 3:
            detailVC.textField.placeholder = "Enter profession"
            detailVC.textField.text = currentUser?.profession
        case 4:
            detailVC.textField.placeholder = "Enter bio"
            detailVC.textField.text = currentUser?.bio
        default:
            detailVC.textField.placeholder = "Enter bio"
        }
        detailVC.currentUser = currentUser
        detailVC.section = section
        detailVC.setInfo()
        self.present(navigationVc, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .white.withAlphaComponent(0.9)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
    
    private func addAllTargets() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(didTapBack))
        
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
        
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            self.currentUser = User(dictionary: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    private func loadUserPhotos() {
        guard let imageURL = currentUser?.imagesURL,
              let url = URL(string: imageURL) else { return }
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.firstButtonsStackView.firstSelectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapBack() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSelectPhoto(button: UIButton) {
        let imagePicker = SettingsImagePicker()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    @objc func loadList(notification: NSNotification){
        fetchCurrentUser()
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto = info[.originalImage] as? UIImage else {return}
        let imageButton = (picker as? SettingsImagePicker)?.imageButton
        imageButton?.setImage(selectedPhoto.withRenderingMode(.alwaysOriginal),
                                                                for: .normal)
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

