//
//  BottomButtonsControlsStackView.swift
//  Tinder
//
//  Created by Эван Крошкин on 6.06.22.
//

import UIKit

class BottomButtonsControlsStackView: UIStackView {
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.addStandartButtonWith(image: Constants.Image.replay?.withRenderingMode(.alwaysOriginal))
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addStandartButtonWith(image: Constants.Image.hurt?.withRenderingMode(.alwaysOriginal))
        return button
    }()
    
    lazy var superLikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addStandartButtonWith(image: Constants.Image.star?.withRenderingMode(.alwaysOriginal))
        return button
    }()
    
    lazy var dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addStandartButtonWith(image: Constants.Image.cross?.withRenderingMode(.alwaysOriginal))
        return button
    }()
    
    lazy var thunderButton: UIButton = {
        let button = UIButton(type: .system)
        button.addStandartButtonWith(image: Constants.Image.lightning?.withRenderingMode(.alwaysOriginal))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        distribution = .fillEqually
        [refreshButton, dislikeButton, superLikeButton, likeButton, thunderButton].forEach { addArrangedSubview($0) }
    }
    
}
