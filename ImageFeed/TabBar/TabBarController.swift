//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/8.
//

import UIKit

final class TabBarController: UITabBarController {
    
    weak var coordinator: ProfileCoordinatorDelegate?
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let tokenStorage: OAuth2TokenStorageProtocol
    
    init(profileService: ProfileServiceProtocol,
         profileImageService: ProfileImageServiceProtocol,
         tokenStorage: OAuth2TokenStorageProtocol,
    ) {
        
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.tokenStorage = tokenStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setControllersToTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypWhiteAlpha50
      
    }
    
    private func setControllersToTabBar() {
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditorialActive),
            selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        
        let presenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService,
            tokenStorage: tokenStorage)
        
        profileViewController.presenter = presenter
        presenter.view = profileViewController
        presenter.coordinator = coordinator
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

