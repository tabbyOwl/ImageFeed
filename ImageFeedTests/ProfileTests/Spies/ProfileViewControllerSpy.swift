//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/23.
//
import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var profile: Profile?
    var presenter: ProfilePresenterProtocol?
    var showProfileCalled = false
    var setAvatarCalled = false
    var showLogoutConfirmationCalled = false
    
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
}
