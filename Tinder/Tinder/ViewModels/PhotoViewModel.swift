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

struct PhotoViewModel {
    let imageString: String
    let attributedText: NSAttributedString
    let textAlignment: NSTextAlignment
}
