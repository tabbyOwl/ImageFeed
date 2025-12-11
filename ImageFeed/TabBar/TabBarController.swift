//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/8.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypWhiteAlpha50
        setControllersToTabBar()
    }
    
    private func setControllersToTabBar() {
        let imagesListViewController = ImagesListViewController()
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditorialActive),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
