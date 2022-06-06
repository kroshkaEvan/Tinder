//
//  TopNavigationStackView.swift
//  Tinder
//
//  Created by Эван Крошкин on 6.06.22.
//

import UIKit

class TopNavigationStackView: UIStackView {
    private lazy var images = [Constants.Image.person, Constants.Image.fire, Constants.Image.chat]
    
    private lazy var buttonSubviews = self.images.map { (image) -> UIView in
        let button = UIButton(type: .system)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtonSubviews()
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButtonSubviews() {
        buttonSubviews.forEach { someButton in
            addArrangedSubview(someButton)
        }
    }
}
