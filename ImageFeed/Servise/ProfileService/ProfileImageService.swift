//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/7.
//
import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init(task: URLSessionTask? = nil) {
        self.task = task
    }
    
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var decoder = SnakeCaseJSONDecoder()
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        guard let token = UserDefaults.standard.string(forKey: Constants.oAuthTokenUserDefaultsKey) else {
            print("Failed to get token from storage")
            completion(.failure(NetworkError.invalidToken))
            return }
        
        guard let request = makeProfileImageRequest(token: token, username: username) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = URLSession.shared.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                let avatar = data.profileImage.large
                self?.avatarURL = avatar
                completion(.success(avatar))
            case .failure(let error):
                print("[ProfileImageService]: error \(error)")
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
