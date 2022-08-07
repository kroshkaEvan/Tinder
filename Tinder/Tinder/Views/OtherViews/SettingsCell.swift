//
//  SettingsCell.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.08.22.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    lazy var infoLabel: CustomInfoLabel = {
        let textField = CustomInfoLabel()
        textField.textInsets = .init(top: 10, left: 40, bottom: 10, right: 0)
        textField.font = UIFont.systemFont(ofSize: 20,
                                           weight: .semibold)
        return textField
    }()
    
    lazy var chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"),
                        for: .normal)
        button.tintColor = .lightGray.withAlphaComponent(0.8)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(infoLabel)
        addSubview(chevronButton)
        infoLabel.fillSuperview()
        chevronButton.anchor(top: self.topAnchor,
                             leading: nil,
                             bottom: self.bottomAnchor,
                             trailing: self.trailingAnchor,
                             padding: .init(top: 0, left: 0,
                                            bottom: 0, right: 15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
