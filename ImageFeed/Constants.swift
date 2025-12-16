//
//  Constants.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/3.
//
import Foundation

//@lanaol

//enum Constants {
//    static let accessKey = "KGY3bZpnTNQF6hzSyJ4dCNumfe-17IAy8AzCoyUXt3Q"
//    static let secretKey = "pu3VsLopQZPcnFlBofNqRVfNxh1YutCbo-fqhGUEF2A"
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//    static let accessScope = "public+read_user+write_likes"
//    static let defaultBaseURL: URL = {
//        guard let url = URL(string: "https://api.unsplash.com/") else {
//            assertionFailure("Invalid base URL")
//            return URL(fileURLWithPath: "/")
//        }
//        return url
//    }()
//    static let oAuthTokenKey = "OAuthToken"
//}

//@tabbyOwl

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
    static let oAuthTokenKey = "OAuthToken"
}
