//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
nonisolated
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
