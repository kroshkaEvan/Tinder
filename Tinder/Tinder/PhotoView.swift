//
//  PhotoView.swift
//  Tinder
//
//  Created by Эван Крошкин on 8.06.22.
//

import UIKit

class PhotoView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Photo.girl6
        translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotoViewLayout()
        addPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotoViewLayout() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(didPanGestureAction))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func didPanGestureAction(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            gestureChanged(gesture)
        case .ended:
            gestureEnded()
        default:
            ()
        }
    }
    
    fileprivate func gestureChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x,
                                           y: translation.y)
    }
    
    fileprivate func gestureEnded() {
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: { self.transform = .identity})
    }
    
}
