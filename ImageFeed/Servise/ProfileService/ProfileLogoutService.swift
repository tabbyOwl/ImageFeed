//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/16.
//

import Foundation
import WebKit

protocol ProfileLogoutServiceProtocol {
    func logout()
}

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let tokenStorage: OAuth2TokenStorageProtocol
    private let imagesListService: ImagesListServiceProtocol
    
    init(
        profileService: ProfileServiceProtocol,
        profileImageService: ProfileImageServiceProtocol,
        tokenStorage: OAuth2TokenStorageProtocol,
        imagesListService: ImagesListServiceProtocol
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.tokenStorage = tokenStorage
        self.imagesListService = imagesListService
    }
    
    func logout() {
        cleanCookies()
        resetServicesData()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func resetServicesData() {
            self.profileService.clearProfile()
            self.profileImageService.clearAvatar()
            self.imagesListService.clearPhotos()
            self.tokenStorage.clearToken()
    }
}

