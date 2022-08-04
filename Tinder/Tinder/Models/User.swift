//
//  User.swift
//  Tinder
//
//  Created by Эван Крошкин on 11.06.22.
//

import Foundation
import UIKit

struct User: ProducesPhotoCardViewModel {
    var name: String?
    var age: Int?
    var profession: String?
    var imagesURL: String?
    var uid: String?
    var bio: String?
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["userName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String ?? ""
        self.imagesURL = dictionary["imagesURL"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
    }
    
    func getPhotoViewModel() -> PhotoCardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 30,
                                                                                             weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age ?? 0)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 26,
                                                                                       weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession ?? "")",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 20,
                                                                                       weight: .regular)]))
        return PhotoCardViewModel(imagesString: [imagesURL ?? ""],
                                  attributedText: attributedText,
                                  textAlignment: .left)
    }
}
