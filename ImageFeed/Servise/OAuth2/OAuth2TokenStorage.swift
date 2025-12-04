//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import UIKit

final class OAuth2TokenStorage {
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "OAuthToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OAuthToken")
        }
    }
}
