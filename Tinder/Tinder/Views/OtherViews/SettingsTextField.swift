//
//  SettingsTextField.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.08.22.
//

import UIKit

class SettingsTextField: UITextField {
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0,
                     height: 45)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 25,
                              dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 25,
                              dy: 0)
    }

}
