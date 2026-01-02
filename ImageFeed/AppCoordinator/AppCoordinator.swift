//
//  AppCoordinator.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/22.
//
import UIKit

final class AppAssembly {
    lazy var profileService: ProfileServiceProtocol = ProfileService()
    lazy var profileImageService: ProfileImageServiceProtocol = ProfileImageService()
    lazy var tokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    lazy var oAuth2Service: OAuth2ServiceProtocol = OAuth2Service(storage: tokenStorage)
    lazy var imagesListService: ImagesListServiceProtocol = ImagesListService()
}

final class AppCoordinator {
    private let assembly: AppAssembly
    private let window: UIWindow
    
    init(window: UIWindow, assembly: AppAssembly) {
        self.window = window
        self.assembly = assembly
    }
    
    func start() {
        let splashVC = SplashViewController()
        let presenter = SplashViewPresenter(
            view: splashVC,
            profileService: assembly.profileService,
            profileImageService: assembly.profileImageService,
            tokenStorage: assembly.tokenStorage,
            coordinator: self
        )
        
        splashVC.presenter = presenter
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: SplashCoordinatorDelegate {
    func showAuth() {
        let authVC = AuthViewController(oAuth2Service: assembly.oAuth2Service)
        authVC.delegate = self
        window.rootViewController?.present(authVC, animated: true)
    }
    
    func showMain() {
        let tabBar = TabBarController(
            profileService: assembly.profileService,
            profileImageService: assembly.profileImageService,
            imagesListService: assembly.imagesListService,
            tokenStorage: assembly.tokenStorage
        )
        tabBar.coordinator = self
        window.rootViewController = tabBar
    }
}

extension AppCoordinator: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        start()
    }
}

extension AppCoordinator: ProfileCoordinatorDelegate {
    func didLogout() {
        start()
    }
}
