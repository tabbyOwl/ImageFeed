//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/16.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    //       private let imagesListService: ImagesListServiceProtocol
    
    init(
        profileService: ProfileServiceProtocol,
        profileImageService: ProfileImageServiceProtocol
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
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
        profileService.clearProfile()
        profileImageService.clearAvatar()
        ImagesListService.shared.clearPhotos()
        OAuth2TokenStorage.shared.clearToken()
    }
}

