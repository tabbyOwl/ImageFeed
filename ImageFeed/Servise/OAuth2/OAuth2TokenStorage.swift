//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Constants.oAuthTokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Constants.oAuthTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Constants.oAuthTokenKey)
            }
        }
    }
}
