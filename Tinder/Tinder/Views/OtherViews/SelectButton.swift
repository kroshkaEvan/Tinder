//
//  SelectButton.swift
//  Tinder
//
//  Created by Эван Крошкин on 1.08.22.
//

import UIKit

class SelectButton: UIButton {
    
    // MARK: - Public Properties
    
    let gradientColors: [UIColor]
    let shadowColor: UIColor
    let cornerRadius: CGFloat
    let startPoint: CGPoint
    let endPoint: CGPoint
    
    // MARK: - Initializers
    
    required init(gradientColors: [UIColor] = [UIColor.white,
                                               Constants.Color.topGradienApp],
                  shadowColor: UIColor = UIColor.lightGray,
                  cornerRadius: CGFloat = 12,
                  startPoint: CGPoint = CGPoint(x: 0.3, y: 0.3),
                  endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        self.gradientColors = gradientColors
        self.shadowColor = shadowColor
        self.cornerRadius = cornerRadius
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(frame: .zero)
        addImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = nil
        addGradienLayer()
        addShadow()
    }
    
    override var isHighlighted: Bool {
        didSet {
            let xScale : CGFloat = isHighlighted ? 0.925 : 1.0
            let yScale : CGFloat = isHighlighted ? 0.95 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale,
                                                       y: yScale)
                self.transform = transformation
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func addGradienLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addShadow() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = cornerRadius * 2
        layer.shadowOpacity = 2.0
        layer.cornerRadius = cornerRadius
    }
    
    private func addImage() {
        imageView?.contentMode = .scaleAspectFit
        setImage(UIImage(named: "camera"), for: .normal)
    }
}
