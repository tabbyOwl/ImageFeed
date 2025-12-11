//
//  Profile.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/6.
//

struct ProfileResult: Codable {
    let username: String
    let name: String
    let bio: String?
}

struct UserResult: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: PhotoURL
    let likes: Int
}

struct PhotoURL: Codable {
    let thumb: String
    let full: String
}
