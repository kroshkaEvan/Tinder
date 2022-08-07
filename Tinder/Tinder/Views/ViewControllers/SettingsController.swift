//
//  SettingsController.swift
//  Tinder
//
//  Created by Эван Крошкин on 31.07.22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
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
    
    private lazy var progressHUD = JGProgressHUD(style: .dark)
        
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchNewSettingsUser),
                                               name: NSNotification.Name(rawValue: "settingsUser"),
                                               object: nil)
    }
    
    // MARK: - Initializers
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = view.frame.size.width * 0.85
        if section == 0 {
            return height
        }
        return 25
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = CustomInfoLabel()
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
        case 4:
            headerLabel.text = "Bio"
            return headerLabel
        case 5:
            headerLabel.text = "Age range"
            return headerLabel
        default:
            headerLabel.text = "Bio"
            return headerLabel
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default,
                                reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.infoLabel.text = currentUser?.name
        case 2:
            if let age = currentUser?.age {
                cell.infoLabel.text = String(age)
            }
        case 3:
            cell.infoLabel.text = currentUser?.profession
        case 4:
            cell.infoLabel.text = currentUser?.bio
        case 5:
            if let minAge = currentUser?.minSeekingAge,
               let maxAge = currentUser?.maxSeekingAge{
                cell.infoLabel.text = "\(minAge) - \(maxAge)"
            }
        default:
            cell.infoLabel.text = "Enter bio"
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
            detailVC.setupLayout(type: .textField)
        case 2:
            detailVC.setupLayout(type: .textField)
            detailVC.textField.placeholder = "Enter age"
            if let age = currentUser?.age {
                detailVC.textField.text = String(age)
            }
        case 3:
            detailVC.setupLayout(type: .textField)
            detailVC.textField.placeholder = "Enter profession"
            detailVC.textField.text = currentUser?.profession
        case 4:
            detailVC.setupLayout(type: .textField)
            detailVC.textField.placeholder = "Enter bio"
            detailVC.textField.text = currentUser?.bio
        case 5:
            detailVC.minSlider.value = Float(currentUser?.minSeekingAge ?? 18)
            detailVC.maxSlider.value = Float(currentUser?.maxSeekingAge ?? 60)
//            detailVC.setMaxAge(slider: detailVC.maxSlider)
//            detailVC.setMinAge(slider: detailVC.minSlider)
            detailVC.setupLayout(type: .slider)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
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
            self.progressHUD.dismiss(animated: true)
            guard let dictionary = snapshot?.data() else { return }
            self.currentUser = User(dictionary: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    private func loadUserPhotos() {
        
        if let imageURL = currentUser?.imagesURL, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.firstButtonsStackView.firstSelectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }

        if let imageURL = currentUser?.imagesURL2, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.firstButtonsStackView.secondSelectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }

        if let imageURL = currentUser?.imagesURL3, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.firstButtonsStackView.thirdSelectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }

        if let imageURL = currentUser?.imagesURL4, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.secondButtonsStackView.firstSelectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }

        if let imageURL = currentUser?.imagesURL5, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.secondButtonsStackView.secondSelectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }

        if let imageURL = currentUser?.imagesURL6, let url = URL(string: imageURL) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.secondButtonsStackView.thirdSelectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapBack() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let documentData = ["userName" : currentUser?.name ?? "",
                            "uid" : currentUser?.uid ?? "",
                            "imagesURL" : currentUser?.imagesURL ?? "",
                            "imagesURL2" : currentUser?.imagesURL2 ?? "",
                            "imagesURL3" : currentUser?.imagesURL3 ?? "",
                            "imagesURL4" : currentUser?.imagesURL4 ?? "",
                            "imagesURL5" : currentUser?.imagesURL5 ?? "",
                            "imagesURL6" : currentUser?.imagesURL6 ?? "",
                            "age" : currentUser?.age ?? 18,
                            "profession" : currentUser?.profession ?? "",
                            "bio" : currentUser?.bio ?? "",
                            "minSeekingAge" : currentUser?.minSeekingAge ?? 18,
                            "maxSeekingAge" : currentUser?.maxSeekingAge ?? 60] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
            if let error = error {
                print(error)
                return
            }
        }
        self.dismiss(animated: true)
    }
    
    @objc private func didTapSelectPhoto(button: UIButton) {
        let imagePicker = SettingsImagePicker()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    @objc func fetchNewSettingsUser(notification: NSNotification){
        self.progressHUD.show(in: view, animated: true)
        self.progressHUD.textLabel.text = "Saving..."
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
        
        progressHUD.textLabel.text = "Uploading image..."
        progressHUD.show(in: view, animated: true)
        let filename = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedPhoto.jpegData(compressionQuality: 0.75) else {return}
        reference.putData(uploadData,
                          metadata: nil) { [weak self] (nil, error) in
            if let error = error {
                print(error)
                return
            }
            reference.downloadURL { (url, error) in
                if let error = error {
                    print(error)
                    return
                }
                switch imageButton {
                case self?.firstButtonsStackView.firstSelectPhotoButton:
                    self?.currentUser?.imagesURL = url?.absoluteString
                case self?.firstButtonsStackView.secondSelectPhotoButton:
                    self?.currentUser?.imagesURL2 = url?.absoluteString
                case self?.firstButtonsStackView.thirdSelectPhotoButton:
                    self?.currentUser?.imagesURL3 = url?.absoluteString
                case self?.secondButtonsStackView.firstSelectPhotoButton:
                    self?.currentUser?.imagesURL4 = url?.absoluteString
                case self?.secondButtonsStackView.secondSelectPhotoButton:
                    self?.currentUser?.imagesURL5 = url?.absoluteString
                case self?.secondButtonsStackView.thirdSelectPhotoButton:
                    self?.currentUser?.imagesURL6 = url?.absoluteString
                default:
                    return
                }
            }
            
            self?.progressHUD.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

