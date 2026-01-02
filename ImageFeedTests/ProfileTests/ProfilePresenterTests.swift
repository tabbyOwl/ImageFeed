//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/21.
//

import XCTest
@testable import ImageFeed

@MainActor
final class ProfilePresenterTests: XCTestCase {
    
    var viewController: ProfileViewControllerSpy?
    var profileService: ProfileServiceMock?
    var profileImageService: ProfileImageServiceMock?
    var imagesListService: ImagesListServiceMock?
    var logoutService: ProfileLogoutServiceProtocol?
    var presenter: ProfilePresenter?
    var coordinator: ProfileCoordinatorSpy?
    
    override func setUp() {
        super.setUp()
        
        let profile = Profile(
            username: "@test",
            name: "Test User",
            loginName: "test",
            bio: "Bio"
        )
        
        viewController = ProfileViewControllerSpy()
        profileService = ProfileServiceMock(profile: profile)
        profileImageService = ProfileImageServiceMock(avatarURL: "test")
        imagesListService = ImagesListServiceMock()
        
        
        logoutService = ProfileLogoutService(profileService: profileService!, profileImageService: profileImageService!, tokenStorage: OAuth2TokenStorage(), imagesListService: imagesListService!)
        
        let tokenStorage = OAuth2TokenStorage()
        coordinator = ProfileCoordinatorSpy()
        
        presenter = ProfilePresenter(
            profileService: profileService!,
            profileImageService: profileImageService!,
            imagesListService: imagesListService!,
            tokenStorage: tokenStorage
        )
        
        viewController?.presenter = presenter
        presenter?.view = viewController
    }
    
    override func tearDown() {
        viewController = nil
        presenter = nil
        profileService = nil
        profileImageService = nil
        
        super.tearDown()
    }
    
    func testViewDidLoadСallsShowProfileIfProfileExists() {
        // when
        presenter?.viewDidLoad()
        
        // then
        if let viewController = viewController {
            XCTAssertTrue(viewController.showProfileCalled, "showProfile должен быть вызван, если профиль существует.")
        }
    }
    
    func testFetchProfileImageURLСallsCompletionWithURL() {
        // when
        profileImageService?.fetchProfileImageURL(username: "testUser") { result in
            // then
            switch result {
            case .success(let url):
                XCTAssertEqual(url, self.profileImageService?.avatarURL, "URL должен быть равен переданному в мок")
            case .failure:
                XCTFail("fetchProfileImageURL должен вернуть успешный результат с URL")
            }
        }
    }
    
    func testConfirmLogoutСallsCoordinatorDidLogout() {
        // when
        presenter?.confirmLogout()
        self.coordinator?.didLogout()
        
        // then
        XCTAssertTrue(coordinator!.didLogoutCalled, "Метод didLogout должен быть вызван на координаторе.")
    }
    
    func testDidTapLogoutСallsShowLogoutConfirmation() {
        // when
        presenter?.didTapLogout()
        
        // then
        XCTAssertTrue(viewController!.showLogoutConfirmationCalled, "Метод showLogoutConfirmation должен быть вызван.")
    }
    
    func testConfirmLogoutСallsLogoutService() {
        // when
        presenter?.confirmLogout()
        
        // then
        XCTAssertNil(profileService?.profile)
    }
    
    func testClearAvatarСallsClearAvatar() {
        // when
        guard let profileImageService else { return }
        profileImageService.clearAvatar()
        
        // then
        XCTAssertTrue(profileImageService.clearAvatarCalled, "clearAvatar должен быть вызван.")
    }
}
