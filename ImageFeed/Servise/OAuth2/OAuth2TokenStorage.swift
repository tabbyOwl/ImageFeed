//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import Foundation

final class OAuth2TokenStorage {
    
    private let key = "OAuthToken"
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
