//
//  SelectPhotoButtonsStackView.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.08.22.
//

import UIKit

class SelectPhotoButtonsStackView: UIStackView {
    
    // MARK: - Public Properties

    private lazy var firstSelectPhotoButton: SelectButton = {
        let button = SelectButton(cornerRadius: 10)
        return button
    }()
    
    private lazy var secondSelectPhotoButton: SelectButton = {
        let button = SelectButton(cornerRadius: 10)
        return button
    }()
    
    private lazy var thirdSelectPhotoButton: SelectButton = {
        let button = SelectButton(cornerRadius: 10)
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    private func setupLayout() {
        distribution = .fillEqually
        spacing = 10
        axis = .horizontal
        layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        isLayoutMarginsRelativeArrangement = true
        [firstSelectPhotoButton, secondSelectPhotoButton,
         thirdSelectPhotoButton].forEach { addArrangedSubview($0) }
    }
}
