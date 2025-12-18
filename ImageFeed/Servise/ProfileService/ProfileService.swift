//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/6.
//
import UIKit
import Logging

final class ProfileService {
    static let shared = ProfileService()
    
    private init(task: URLSessionTask? = nil) {
        self.task = task
    }
    
    func clearProfile() {
        profile = nil
    }
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var decoder = SnakeCaseJSONDecoder()
    private var logger = Logger(label: "ProfileService")
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let data):
                guard let self else {
                    completion(.failure(NetworkError.invalidRequest))
                    return
                }
                
                let profile = Profile(
                    username: data.username,
                    name: data.name,
                    loginName: "@\(data.username)",
                    bio: data.bio
                )
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                self?.logger.error(
                    "Failed to fetch profile",
                    metadata: [
                        "error": .string("\(error)"),
                        "url": .string(request.url?.absoluteString ?? "unknown")
                    ]
                )
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

