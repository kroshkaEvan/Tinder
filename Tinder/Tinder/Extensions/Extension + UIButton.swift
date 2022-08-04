//
//  Extension + UIButton.swift
//  Tinder
//
//  Created by Эван Крошкин on 31.07.22.
//

import UIKit

extension UIButton {
    func addStandartButtonWith(image: UIImage?) {
        setImage(image,
                 for: .normal)
        contentMode = .scaleAspectFill
    }
}

extension UIEdgeInsets {
   func apply(_ rect: CGRect) -> CGRect {
      return rect.inset(by: self)
   }
}
