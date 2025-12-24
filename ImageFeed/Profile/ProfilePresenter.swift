//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/21.
//
import Foundation

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    func didTapLogout()
    func confirmLogout()
}

protocol ProfileCoordinatorDelegate: AnyObject {
    func didLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    weak var coordinator: ProfileCoordinatorDelegate?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileService: ProfileServiceProtocol
    private var profileImageService: ProfileImageServiceProtocol
    private var tokenStorage: OAuth2TokenStorageProtocol
    private var logoutService: ProfileLogoutServiceProtocol?
    
    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol, tokenStorage: OAuth2TokenStorageProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.tokenStorage = tokenStorage
    }
    
    func viewDidLoad() {
        if let profile = profileService.profile {
                self.view?.showProfile(with: profile)
        }
        loadAvatar()
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func didTapLogout() {
            self.view?.showLogoutConfirmation()
    }
    
    func confirmLogout() {
        self.logoutService = ProfileLogoutService(profileService: self.profileService, profileImageService: self.profileImageService, tokenStorage: self.tokenStorage)
        
            self.logoutService?.logout()
        
            DispatchQueue.main.async {
                self.coordinator?.didLogout()
        }
    }
    
    private func loadAvatar() {
        guard
            let urlString = profileImageService.avatarURL,
            let url = URL(string: urlString)
        else { return }
            self.view?.setAvatar(with: url)
    }
    
    private func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                loadAvatar()
            }
    }
}
