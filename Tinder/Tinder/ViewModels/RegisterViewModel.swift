//
//  RegisterViewModel.swift
//  Tinder
//
//  Created by Эван Крошкин on 26.07.22.
//

import UIKit

class RegisterViewModel {
    var bindableImage = Bindable<UIImage>()
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
    var bindableIsFormValid = Bindable<Bool>()
//    var isFormValidObserver: ((Bool) -> ())?
    private func checkFormValidity() {
        let isFormValid = userName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
}
