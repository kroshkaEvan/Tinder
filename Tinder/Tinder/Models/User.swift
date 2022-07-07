//
//  User.swift
//  Tinder
//
//  Created by Эван Крошкин on 11.06.22.
//

import Foundation
import UIKit

struct User: ProducesPhotoViewModel {
    let name: String
    let age: Int
    let profession: String
    let imagesString: [String]
    
    func getPhotoViewModel() -> PhotoViewModel{
        let attributedText = NSMutableAttributedString(string: name,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 30,
                                                                                             weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 26,
                                                                                       weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 20,
                                                                                       weight: .regular)]))
        return PhotoViewModel(imagesString: imagesString,
                              attributedText: attributedText,
                              textAlignment: .left)
    }
}
