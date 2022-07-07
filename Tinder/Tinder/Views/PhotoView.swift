//
//  PhotoView.swift
//  Tinder
//
//  Created by Эван Крошкин on 8.06.22.
//

import UIKit

class PhotoView: UIView {
    
    var viewModel: PhotoViewModel? {
        didSet {
            if let viewModel = viewModel {
                imageView.image = UIImage(named: viewModel.imageString)
                infoLabel.attributedText = viewModel.attributedText
                infoLabel.textAlignment = viewModel.textAlignment
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 35,
                                       weight: .heavy)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPhotoViewLayout()
        addPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupGradienLayerImage()
    }
    
    private func setupPhotoViewLayout() {
        [imageView, infoLabel].forEach { addSubview($0) }
        imageView.fillSuperview()
        infoLabel.anchor(top: nil,
                         leading: self.leadingAnchor,
                         bottom: self.bottomAnchor,
                         trailing: self.trailingAnchor,
                         padding: .init(top: 0, left: 20,
                                        bottom: 20, right: 20))
        self.bringSubviewToFront(infoLabel)
    }
    
    private func setupGradienLayerImage() {
        let gradienLayer = CAGradientLayer()
        gradienLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradienLayer.locations = [0.5, 1.2]
        gradienLayer.frame = self.frame
        imageView.layer.addSublayer(gradienLayer)
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(didPanGestureAction))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func didPanGestureAction(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ subviews in
                subviews.layer.removeAllAnimations()
            })
        case .changed:
            gestureChanged(gesture)
        case .ended:
            gestureEnded(gesture)
        default:
            ()
        }
    }
    
    private func gestureChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTranformetion = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTranformetion.translatedBy(x: translation.x,
                                                              y: translation.y)
    }
    
    private func gestureEnded(_ gesture: UIPanGestureRecognizer) {
        let treshold: CGFloat = 130
        
        let rightDismissPhoto = gesture.translation(in: nil).x > treshold
        let leftDismissPhoto = gesture.translation(in: nil).x < -treshold
        var translationX: CGFloat = 1000

//        let shouldDismissPhoto = gesture.translation(in: nil).x > treshold
//        let translationX: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1

        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: {
//            if shouldDismissPhoto {
//                self.frame = CGRect(x: 600 * translationX, y: 0,
//                                    width: self.frame.width,
//                                    height: self.frame.height)

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
                if rightDismissPhoto || leftDismissPhoto {
                    self.removeFromSuperview()
                }
            }
    }
}
