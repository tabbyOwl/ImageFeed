//
//  SplashViewPresenter.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/21.
//

protocol SplashViewPresenterProtocol {
    func didAuthenticate()
    func viewDidAppear()
}

final class SplashViewPresenter: SplashViewPresenterProtocol {
    private weak var view: SplashViewControllerProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let tokenStorage = OAuth2TokenStorage.shared
    
    init(view: SplashViewControllerProtocol,
         profileService: ProfileServiceProtocol,
         profileImageService: ProfileImageServiceProtocol) {
        self.view = view
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidAppear() {
        print("Splash appeared. Token = \(tokenStorage.token != nil)")
        print("🍎") // MARK: viewDidAppear вызывается раньше чем удаляется токен!
        if let token = tokenStorage.token {
            fetchProfile(token: token)
            print("🕎")
        } else {
            view?.presentAuthViewController()
        }
    }
    
    func didAuthenticate() {
        guard let token = tokenStorage.token else { return }
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
        view?.showLoading()
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            view?.hideLoading()
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                view?.switchToTabBar(profileService: profileService, profileImageService: profileImageService)
            case .failure(let error):
                view?.showError(error)
            }
        }
    }
}
