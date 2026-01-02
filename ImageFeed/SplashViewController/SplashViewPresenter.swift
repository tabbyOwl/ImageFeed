//
//  SplashViewPresenter.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/21.
//
import Foundation

protocol SplashViewPresenterProtocol {
    func didAuthenticate()
    func viewDidAppear()
}

protocol SplashCoordinatorDelegate: AnyObject {
    func showAuth()
    func showMain()
}

final class SplashViewPresenter: SplashViewPresenterProtocol {
    private var coordinator: SplashCoordinatorDelegate
    private weak var view: SplashViewControllerProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let tokenStorage: OAuth2TokenStorageProtocol
    
    init(view: SplashViewControllerProtocol,
         profileService: ProfileServiceProtocol,
         profileImageService: ProfileImageServiceProtocol,
         tokenStorage: OAuth2TokenStorageProtocol,
         coordinator: SplashCoordinatorDelegate) {
        self.view = view
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.tokenStorage = tokenStorage
        self.coordinator = coordinator
    }
    
    func viewDidAppear() {
        if let token = self.tokenStorage.token {
            self.fetchProfile(token: token)
        }
        else {
            self.coordinator.showAuth()
        }
    }
    
    func didAuthenticate() {
        self.coordinator.showMain()
    }
    
    private func fetchProfile(token: String) {
        view?.showLoading()
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            self.view?.hideLoading()
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                self.coordinator.showMain()
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
}
