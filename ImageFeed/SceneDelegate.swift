//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/11/27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let profileService = ProfileService()
        private let profileImageService = ProfileImageService()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let splashViewController = SplashViewController()
                let presenter = SplashViewPresenter(
                    view: splashViewController,
                    profileService: profileService,
                    profileImageService: profileImageService
                )
                splashViewController.presenter = presenter
                
                window?.rootViewController = splashViewController
                window?.makeKeyAndVisible()
    }
}

