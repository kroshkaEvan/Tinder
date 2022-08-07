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
    
    enum TypeLayout {
        case textField, slider
    }
    
    // MARK: - Public properties

    lazy var textField: CustomTextField = {
        let textField = CustomTextField(padding: 24,
                                              height: 50)
        textField.font = .systemFont(ofSize: 35,
                                     weight: .semibold)
        return textField
    }()
    
    lazy var minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        return slider
    }()
    
    lazy var maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        return slider
    }()
    
    lazy var minLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Min "
        return label
    }()
    
    lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Max "
        return label
    }()
    
    lazy var doubleSlider: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider])])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    var currentUser: User?
    var section: Int?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllTarget()
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setupAllTarget() {
        textField.addTarget(self,
                            action: #selector(setInfo),
                            for: .editingChanged)
        minSlider.addTarget(self,
                            action: #selector(setMinAge),
                            for: .valueChanged)
        maxSlider.addTarget(self,
                            action: #selector(setMaxAge),
                            for: .valueChanged)
    }
    
    func setupLayout(type: TypeLayout) {
        switch type {
        case .textField:
            view.backgroundColor = .lightGray
            view.addSubview(textField)
            textField.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                             bottom: nil, trailing: view.trailingAnchor,
                             padding: .init(top: 100, left: 20,
                                            bottom: 0, right: 20),
                             size: .init(width: view.frame.size.width * 0.8,
                                         height: 60))
        case .slider:
            view.backgroundColor = .lightGray
            view.addSubview(doubleSlider)
            doubleSlider.centerInSuperview(size: .init(width: view.frame.size.width * 0.8,
                                                       height: 150))
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapSave() {
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
    
    @objc func setMinAge(slider: UISlider) {
        DispatchQueue.main.async {
            self.minLabel.text = "Min: \(Int(slider.value))"
            self.currentUser?.minSeekingAge = Int(self.minSlider.value)
        }
    }
    
    @objc func setMaxAge(slider: UISlider) {
        DispatchQueue.main.async {
            self.maxLabel.text = "Max: \(Int(slider.value))"
            self.currentUser?.maxSeekingAge = Int(self.maxSlider.value)
        }
    }

}
