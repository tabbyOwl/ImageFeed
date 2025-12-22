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

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileService: ProfileServiceProtocol
    private var profileImageService: ProfileImageServiceProtocol
    
    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        if let profile = profileService.profile {
            view?.showProfile(with: profile)
        }
        loadAvatar()
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func didTapLogout() {
        view?.showLogoutConfirmation()
    }
    
    
    func confirmLogout() {
        let profileLogoutService = ProfileLogoutService(profileService: profileService, profileImageService: profileImageService)
        profileLogoutService.logout()
        view?.showSplashScreen()
    }
    
    private func loadAvatar() {
        guard
            let urlString = profileImageService.avatarURL,
            let url = URL(string: urlString)
        else { return }
        view?.setAvatar(with: url)
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
