//
//  TopNavigationStackView.swift
//  Tinder
//
//  Created by Эван Крошкин on 6.06.22.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    // MARK: - Public Properties
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.Image.person?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    lazy var fireButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Constants.Image.fire?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackViewLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupStackViewLayout() {
        distribution = .equalCentering
        [settingsButton, fireButton].forEach { addArrangedSubview($0) }
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 25,
                              bottom: 0, right: 25)
    }
}
