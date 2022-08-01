//
//  Advertiser.swift
//  Tinder
//
//  Created by Эван Крошкин on 29.06.22.
//

import Foundation
import UIKit

struct Advertiser: ProducesPhotoCardViewModel {
    let brandName: String
    let title: String
    let posterName: String
    
    func getPhotoViewModel() -> PhotoCardViewModel {
        let attributedText = NSMutableAttributedString(string: title,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 30,
                                                                                             weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n" + brandName,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 24,
                                                                                       weight: .bold)]))
                                                       
        return PhotoCardViewModel(imagesString: [posterName],
                              attributedText: attributedText,
                              textAlignment: .center)
    }
}
