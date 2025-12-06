//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.oAuthTokenUserDefaultsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.oAuthTokenUserDefaultsKey)
        }
    }
}
