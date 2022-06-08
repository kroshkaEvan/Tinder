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
        imageView.image = Constants.Photo.girl2
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
            gestureEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func gestureChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTranformetion = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTranformetion.translatedBy(x: translation.x,
                                                              y: translation.y)
    }
    
    fileprivate func gestureEnded(_ gesture: UIPanGestureRecognizer) {
        let treshold: CGFloat = 130
        let rightDismissPhoto = gesture.translation(in: nil).x > treshold
        let leftDismissPhoto = gesture.translation(in: nil).x < -treshold
        var translationX: CGFloat = 1000
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: {
            if rightDismissPhoto || leftDismissPhoto {
                if leftDismissPhoto {
                    translationX = -1000
                }
                let transform = self.transform.translatedBy(x: translationX,
                                                            y: 0)
                self.transform = transform
            } else {
                self.transform = .identity
            }}) { (_) in
                self.transform = .identity
                if let superview = self.superview {
                    self.frame = CGRect(x: 0, y: 0,
                                        width: superview.frame.width,
                                        height: superview.frame.height)
                }
            }
    }
}
