//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/11/27.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    private let profileService = ProfileService()
    private let profileImageService = ProfileImageService()
    private let tokenStorage = OAuth2TokenStorage()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        let assembly = AppAssembly()
        let coordinator = AppCoordinator(
            window: window,
            assembly: assembly
        )
        self.appCoordinator = coordinator
        
        coordinator.start()
    }
}

