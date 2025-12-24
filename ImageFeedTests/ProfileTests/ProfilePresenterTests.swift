//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/21.
//

import XCTest
@testable import ImageFeed


class ProfileLogoutServiceMock: ProfileLogoutServiceProtocol {
    var logoutCalled = false
    
    func logout() {
        logoutCalled = true
    }
}

@MainActor
final class ProfilePresenterTests: XCTestCase {
    
    var viewController: ProfileViewControllerSpy?
    var profileService: ProfileServiceMock?
    var profileImageService: ProfileImageServiceMock?
    var logoutService: ProfileLogoutServiceMock?
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
        logoutService = ProfileLogoutServiceMock()
        let tokenStorage = OAuth2TokenStorage()
        coordinator = ProfileCoordinatorSpy()

        presenter = ProfilePresenter(
            profileService: profileService!,
            profileImageService: profileImageService!,
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

    func testViewDidLoad_callsShowProfileIfProfileExists() {
        // When
        presenter?.viewDidLoad()
        
        // Then
        if let viewController = viewController {
            XCTAssertTrue(viewController.showProfileCalled, "showProfile должен быть вызван, если профиль существует.")
        }
    }

    func testFetchProfileImageURL_callsCompletionWithURL() {
        // When
        profileImageService?.fetchProfileImageURL(username: "testUser") { result in
            // Then
            switch result {
            case .success(let url):
                XCTAssertEqual(url, self.profileImageService?.avatarURL, "URL должен быть равен переданному в мок")
            case .failure:
                XCTFail("fetchProfileImageURL должен вернуть успешный результат с URL")
            }
        }
    }
    
    func testConfirmLogout_callsCoordinatorDidLogout() {
        // Given
        XCTAssertNotNil(presenter, "Презентер не должен быть nil")
        let expectation = self.expectation(description: "didLogout ожидание")
        
        // When
        presenter?.confirmLogout()

        // Then
        DispatchQueue.main.async(qos: .userInteractive) {
            self.coordinator?.didLogout()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil) // Даем время для завершения асинхронной операции
        XCTAssertTrue(coordinator!.didLogoutCalled, "Метод didLogout должен быть вызван на координаторе.")
    }

        func testDidTapLogout_callsShowLogoutConfirmation() {
            
            // When
            presenter?.didTapLogout()
            
            // Then
            XCTAssertTrue(viewController!.showLogoutConfirmationCalled, "Метод showLogoutConfirmation должен быть вызван.")
        }

        func testConfirmLogout_callsLogoutService() {
            // Given
            XCTAssertNotNil(presenter, "Презентер не должен быть nil")
            let expectation = self.expectation(description: "didLogout ожидание")

            // When
            presenter?.confirmLogout()
            
            // Then
            waitForExpectations(timeout: 1.0, handler: nil)
            XCTAssertTrue(logoutService!.logoutCalled, "Метод logout должен быть вызван на сервисе логаута.")
        }
    
    func testClearAvatar_callsClearAvatar() {
        // When
        guard let profileImageService else { return }
        profileImageService.clearAvatar()
        // Then
        XCTAssertTrue(profileImageService.clearAvatarCalled, "clearAvatar должен быть вызван.")
    }
}
