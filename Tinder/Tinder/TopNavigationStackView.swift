//
//  TopNavigationStackView.swift
//  Tinder
//
//  Created by Эван Крошкин on 6.06.22.
//

import UIKit

class TopNavigationStackView: UIStackView {
    private lazy var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.Image.chat?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.Image.person?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    private lazy var fireButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.Image.fire?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackViewLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackViewLayout() {
        distribution = .equalCentering
        [settingsButton, fireButton, chatButton].forEach { addArrangedSubview($0) }
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 25,
                              bottom: 0, right: 25)
    }
}
