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
