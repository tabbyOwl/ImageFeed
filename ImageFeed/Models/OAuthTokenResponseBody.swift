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

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType   = "token_type"
        case scope
        case createdAt   = "created_at"
    }
}
