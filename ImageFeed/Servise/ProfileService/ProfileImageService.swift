//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/7.
//
import UIKit
import SwiftKeychainWrapper
import Logging

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var decoder = SnakeCaseJSONDecoder()
    private let logger = Logger(label: "ProfileImageService")
    
    private init(task: URLSessionTask? = nil) {
        self.task = task
    }
    
    func clearAvatar() {
        avatarURL = nil
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        guard let token = KeychainWrapper.standard.string(forKey: Constants.oAuthTokenKey) else {
            logger.error("Failed to get token from storage")
            completion(.failure(NetworkError.invalidToken))
            return }
        
        guard let request = makeProfileImageRequest(token: token, username: username) else {
            logger.error("Failed to create URLRequest for user \(username)")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                
                guard let self else { return }
                let avatar = data.profileImage.large
                self.avatarURL = avatar
                completion(.success(avatar))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL ?? ""]
                    )
                
            case .failure(let error):
                self?.logger.error("Failed to fetch profile image URL for user \(username)",
                                   metadata: [
                                    "error": .string("\(error)"),
                                    "url": "\(request.url?.absoluteString ?? "unknown")"
                                   ])
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            logger.critical("Invalid URL for username: \(username)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
