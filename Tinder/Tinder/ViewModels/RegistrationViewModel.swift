//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Эван Крошкин on 26.07.22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

typealias CompletionClosure = (Error?) -> Void

class RegistrationViewModel {
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
    
    private func saveImageToFirebase(completion: @escaping CompletionClosure) {
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        reference.putData(imageData,
                          metadata: nil) { _, error in
            if let error = error {
                completion(error)
                return
            }
            reference.downloadURL{ url, error in
                if let error = error {
                    completion(error)
                    return
                }
                self.bindableIsRegistering.value = false
                let imagesURL = url?.absoluteString ?? ""
                self.saveInfoToFirebase(imagesURL: imagesURL,
                                        completion: completion)

            }
        }
    }
    
    private func saveInfoToFirebase(imagesURL: String,
                                    completion: @escaping CompletionClosure) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let documentData = ["userName" : userName ?? "",
                            "uid" : uid,
                            "imagesURL" : imagesURL] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func performRegitration(completion: @escaping CompletionClosure) {
        bindableIsRegistering.value = true
        
        guard let password = password else {return}
        guard let email = email else {return}

        Auth.auth().createUser(withEmail: email,
                               password: password) {[weak self] (_, error) in
            if let error = error {
                completion(error)
                return
            }
            // Download image to storage
            self?.saveImageToFirebase(completion: completion)
        }
    }
}
