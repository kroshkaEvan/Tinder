//
//  SettingsCell.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.08.22.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    lazy var textField: UITextField = {
        let textField = SettingsTextField()
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
