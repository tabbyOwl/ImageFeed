//
//  ProfileServiceMock.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/23.
//
import ImageFeed
import Foundation

final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: Profile?

    init(profile: Profile?) {
        self.profile = profile
    }

    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        if let profile {
            completion(.success(profile))
        } else {
            completion(.failure(NSError(domain: "test", code: 0)))
        }
    }

    func clearProfile() {
        profile = nil
    }
}
