//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/8.
//

import UIKit

final class TabBarController: UITabBarController {
    weak var coordinator: ProfileCoordinatorDelegate?
    
    //MARK: -Private properties
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let imagesListService: ImagesListServiceProtocol
    private let tokenStorage: OAuth2TokenStorageProtocol
    
    init(profileService: ProfileServiceProtocol,
         profileImageService: ProfileImageServiceProtocol,
         imagesListService: ImagesListServiceProtocol,
         tokenStorage: OAuth2TokenStorageProtocol,
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.imagesListService = imagesListService
        self.tokenStorage = tokenStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setControllersToTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: -Private methods
    private func setupTabBar() {
        tabBar.backgroundColor = .ypBlack
        tabBar.tintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypWhiteAlpha50
        
    }
    
    private func setControllersToTabBar() {
        let imagesListViewController = makeImagesListViewController()
        let imagesListNavigationViewController = UINavigationController(rootViewController: imagesListViewController)
        
        let profileViewController = makeProfileViewController()
        
        self.viewControllers = [imagesListNavigationViewController, profileViewController]
    }
    
    private func makeImagesListViewController() -> ImagesListViewController {
        let imagesListViewController = ImagesListViewController()
        
        let imagesListPresenter = ImagesListViewPresenter(imagesListService: imagesListService)
        
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditorialActive),
            selectedImage: nil
        )
        return imagesListViewController
    }
    
    private func makeProfileViewController() -> ProfileViewController {
        let profileViewController = ProfileViewController()
        
        let profilePresenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService,
            imagesListService: imagesListService,
            tokenStorage: tokenStorage)
        
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profilePresenter.coordinator = coordinator
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil)
        return profileViewController
    }
}

