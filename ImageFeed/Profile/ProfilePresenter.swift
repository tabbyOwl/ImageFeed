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
    
    // MARK: - Private properties
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileService: ProfileServiceProtocol
    private var profileImageService: ProfileImageServiceProtocol
    private var imagesListService: ImagesListServiceProtocol
    private var tokenStorage: OAuth2TokenStorageProtocol
    private var logoutService: ProfileLogoutServiceProtocol?
    
    init(profileService: ProfileServiceProtocol,
         profileImageService: ProfileImageServiceProtocol,
         imagesListService: ImagesListServiceProtocol,
         tokenStorage: OAuth2TokenStorageProtocol)
    {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.imagesListService = imagesListService
        self.tokenStorage = tokenStorage
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Life cycle
    func viewDidLoad() {
        if let profile = profileService.profile {
            self.view?.showProfile(with: profile)
        }
        loadAvatar()
    }
    
    // MARK: - Public methods
    func didTapLogout() {
        self.view?.showLogoutConfirmation()
    }
    
    func confirmLogout() {
        logoutService = ProfileLogoutService(profileService: profileService, profileImageService: profileImageService, tokenStorage: tokenStorage, imagesListService: imagesListService)
        
        logoutService?.logout()
        
        DispatchQueue.main.async {
            self.coordinator?.didLogout()
        }
    }
    
    // MARK: - Private methods
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
