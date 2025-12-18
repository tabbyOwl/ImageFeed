//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import UIKit
import Logging

final class SplashViewController: UIViewController {
    
    //MARK: - Private properties
    private var imageView = UIImageView()
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    weak var delegate: AuthViewControllerDelegate?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let logger = Logger(label: "SplashViewController")
    //MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        if let token = storage.token {
            fetchProfile(token: token)
            switchToTabBarController()
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .ypBlack
        setupImage()
        setupConstraints()
    }
    
    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .vector)
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.heightAnchor.constraint(equalToConstant: 77)
        ])
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) {_ in }
                self.switchToTabBarController()
            case .failure(let error):
                self.logger.error("Failed to load profile info",metadata: [ "error": .string("\(error)")])
            }
        }
    }
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            let navigationVC = UINavigationController(rootViewController: tabBarController)
            navigationVC.modalPresentationStyle = .fullScreen
            self.present(navigationVC, animated: true)
        }
    }
}

// MARK: -AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        DispatchQueue.main.async { [weak self] in
            vc.dismiss(animated: true)
            guard let token = self?.storage.token else {return}
            self?.fetchProfile(token: token)
        }
        switchToTabBarController()
    }
}

