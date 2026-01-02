//
//  ProfileServiceMock.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/23.
//
import ImageFeed
import Foundation

final class ProfileImageServiceMock: ProfileImageServiceProtocol {
    var avatarURL: String?
    var clearAvatarCalled = false
    
    init(avatarURL: String?) {
        self.avatarURL = avatarURL ?? "https://example.com/default-avatar.png" 
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if let avatarURL = self.avatarURL {
            completion(.success(avatarURL))
        } else {
            completion(.failure(NSError(domain: "test", code: 0)))
        }
    }
    
    func clearAvatar() {
        clearAvatarCalled = true
    }
}
