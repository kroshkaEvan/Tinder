//
//  HeaderLabel.swift
//  Tinder
//
//  Created by Эван Крошкин on 2.08.22.
//

import UIKit

class HeaderLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16,
                                        dy: 0))
    }
}
