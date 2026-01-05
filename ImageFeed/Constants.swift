//
//  Constants.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/28.
//
import Foundation

enum Constants {
    
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            assertionFailure("Invalid base URL")
            return URL(fileURLWithPath: "/")
        }
        return url
    }()
    
    
    static let accessKey = "1Go06U5uV3Pq4ezAFlhobgLDDkqytHl6-gXuWTEM3wQ"
    static let secretKey = "AZNX3zMK9ebjtyjV2MHDvJIhVtrcnDuaW47Z1Uu8GE4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let oAuthTokenKey = "OAuthToken"
   
}
