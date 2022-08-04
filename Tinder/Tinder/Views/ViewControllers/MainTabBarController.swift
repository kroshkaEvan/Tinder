//
//  MainTabBarController.swift
//  Tinder
//
//  Created by Эван Крошкин on 5.08.22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = .orange
        setupVCs()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        let scalingRatio = CGFloat(0.7)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.3,
                                                      dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: scalingRatio,
                                                                        y: scalingRatio)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity },
                                       delayFactor: CGFloat(0.3))
        propertyAnimator.startAnimation()
    }
    
    // MARK: - Private Methods
    
    private func createNavController(for rootViewController: UIViewController,
                                     image: UIImage?,
                                     selectedImage: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: PhotoCardController(),
                                   image: UIImage(named: "fire"),
                                   selectedImage: UIImage(named: "fire")),
            createNavController(for: ChatController(),
                                   image: UIImage(named: "chat"),
                                   selectedImage: UIImage(named: "chat"))
        ]
    }
}
