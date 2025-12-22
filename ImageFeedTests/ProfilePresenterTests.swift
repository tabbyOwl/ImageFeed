//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/21.
//

import XCTest
@testable import ImageFeed

final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: Profile?
    init(profile: Profile?) { self.profile = profile }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol, ProfileServiceProtocol {
    
    var profile: Profile?

     
    var presenter: ProfilePresenterProtocol?
    var showProfileCalled = false
    var setAvatarCalled = false
    var showLogoutConfirmationCalled = false
    var showSplashScreenCalled = false
    
    init(profile: Profile? = nil) {
        self.profile = profile
    }

    func showProfile(with profile: Profile) {
        showProfileCalled = true
    }

    func setAvatar(with url: URL) {
        setAvatarCalled = true
    }

    func showLogoutConfirmation() {
        showLogoutConfirmationCalled = true
    }

    func showSplashScreen() {
        showSplashScreenCalled = true
    }
}
@MainActor
final class ProfilePresenterTests: XCTestCase {
    
    var viewController: ProfileViewControllerSpy?
    var profileService: ProfileServiceMock?
    var presenter: ProfilePresenter?
    
    override class func setUp() {
        let profile = Profile(username: "@test", name: "Test User", loginName: "test",  bio: "Bio")
        let viewController = ProfileViewControllerSpy(profile: profile)
        let profileService = ProfileServiceMock(profile: profile)
        let presenter = ProfilePresenter(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
    }
    
    override func tearDown() {
        viewController = nil
        profileService = nil
        presenter = nil
        super.tearDown()
    }


    func testViewDidLoad_callsShowProfileIfProfileExists() {
        //given
        
        //when
        presenter?.viewDidLoad()
        //then
        if let viewController = viewController {
            XCTAssertTrue(viewController.showProfileCalled)
        }
    }

    func testViewDidLoad_callsSetAvatarIfURLExists() {
        //given
        let mockUrl = "https://example.com/avatar.png" // MARK: ДОДЕЛАТЬ!!!
        //when
        presenter?.viewDidLoad()
        
        //then
        if let viewController = viewController {
            XCTAssertTrue(viewController.setAvatarCalled)
        }
    }

    func testDidTapLogout_callsShowLogoutConfirmation() {
        //when
        presenter?.didTapLogout()
        //then
        guard let viewController = viewController else { return }
        XCTAssertTrue(viewController.showLogoutConfirmationCalled)
    }

    func testConfirmLogout_callsShowSplashScreen() {
        
        //when
        presenter?.confirmLogout()
        
        //then
        guard let viewController = viewController else { return }
        XCTAssertTrue(viewController.showSplashScreenCalled)
    }
}
