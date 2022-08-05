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
    var imagesURL2: String?
    var imagesURL3: String?
    var imagesURL4: String?
    var imagesURL5: String?
    var imagesURL6: String?
    var uid: String?
    var bio: String?
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["userName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String ?? ""
        self.imagesURL = dictionary["imagesURL"] as? String ?? ""
        self.imagesURL2 = dictionary["imagesURL2"] as? String ?? ""
        self.imagesURL3 = dictionary["imagesURL3"] as? String ?? ""
        self.imagesURL4 = dictionary["imagesURL4"] as? String ?? ""
        self.imagesURL5 = dictionary["imagesURL5"] as? String ?? ""
        self.imagesURL6 = dictionary["imagesURL6"] as? String ?? ""
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
        
        var imagesURLs = [String]()
        let images = [imagesURL,
                      imagesURL2,
                      imagesURL3,
                      imagesURL4,
                      imagesURL5,
                      imagesURL6,]
        images.forEach { image in
            if let url = image {
                if url != "" {
                    imagesURLs.append(url)
                }
            }
        }
        
        return PhotoCardViewModel(imagesString: imagesURLs,
                                  attributedText: attributedText,
                                  textAlignment: .left)
    }
}
