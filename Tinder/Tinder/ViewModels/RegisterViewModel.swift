//
//  RegisterViewModel.swift
//  Tinder
//
//  Created by Эван Крошкин on 26.07.22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RegisterViewModel {
    var userName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    private func checkFormValidity() {
        let isFormValid = userName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegitration(comletion: @escaping (Error?) -> ()) {
        bindableIsRegistering.value = true
        
        guard let password = password else {return}
        guard let email = email else {return}

        Auth.auth().createUser(withEmail: email,
                               password: password) {[weak self] (_, error) in
            if let error = error {
                comletion(error)
                return
            }
            // Download image to storage
            let fileName = UUID().uuidString
            let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
            let imageData = self?.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            reference.putData(imageData,
                              metadata: nil) { _, error in
                if let error = error {
                    comletion(error)
                    return
                }
                reference.downloadURL { url, error in
                    if let error = error {
                        comletion(error)
                        return
                    }
                    self?.bindableIsRegistering.value = false
                    print(url?.absoluteString ?? "")
                }
            }
        }
    }
}
