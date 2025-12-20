//
//  Constants.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/3.
//
import Foundation

enum Constants {
    static let accessKey = "1Go06U5uV3Pq4ezAFlhobgLDDkqytHl6-gXuWTEM3wQ"
    static let secretKey = "AZNX3zMK9ebjtyjV2MHDvJIhVtrcnDuaW47Z1Uu8GE4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            assertionFailure("Invalid base URL")
            return URL(fileURLWithPath: "/")
        }
        return url
    }()
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let oAuthTokenKey = "OAuthToken"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    let oAuthTokenKey: String
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: Constants.accessKey,
                                     secretKey: Constants.secretKey,
                                     redirectURI: Constants.redirectURI,
                                     accessScope: Constants.accessScope,
                                     authURLString: Constants.unsplashAuthorizeURLString,
                                     defaultBaseURL: Constants.defaultBaseURL,
                                     oAuthTokenKey: Constants.oAuthTokenKey)
        }

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL, oAuthTokenKey: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.oAuthTokenKey = oAuthTokenKey
    }
}
