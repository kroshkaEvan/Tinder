//
//  PhotoViewModel.swift
//  Tinder
//
//  Created by Эван Крошкин on 28.06.22.
//

import Foundation
import UIKit

protocol ProducesPhotoViewModel {
    func getPhotoViewModel() -> PhotoViewModel 
}

class PhotoViewModel {
    let imagesString: [String]
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
    
    private var imageIndex = 0 {
        didSet {
            let imageName = imagesString[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    init(imagesString: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imagesString = imagesString
        self.attributedText = attributedText
        self.textAlignment = textAlignment
    }
    
    func goToNextPhoto() {
        imageIndex = min(imageIndex + 1, imagesString.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
