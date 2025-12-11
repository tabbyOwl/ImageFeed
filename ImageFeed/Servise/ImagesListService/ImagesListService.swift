//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/11.
//

import Foundation
import CoreGraphics
import SwiftKeychainWrapper

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private var decoder = SnakeCaseJSONDecoder()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private init(task: URLSessionTask? = nil) {
        self.task = task
    }
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
               return
           }
        
        guard let token = KeychainWrapper.standard.string(forKey: Constants.oAuthTokenKey) else {
            print("Failed to get token from storage")
            completion(.failure(NetworkError.invalidToken))
            return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            
            guard let self else { return }
            switch result {
            case .success(let photoResult):
                let newPhotos: [Photo] = photoResult.map { self.convert(photoResult: $0)}
                
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                // Отправляем уведомление контроллеру
                               NotificationCenter.default.post(
                                   name: ImagesListService.didChangeNotification,
                                   object: self
                               )

            case .failure(let error):
                print("[ProfileImageService]: error \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func convert(photoResult: PhotoResult) -> Photo {
        let id = photoResult.id
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        let date = dateFromISO8601(photoResult.createdAt)
        let description = photoResult.description
        let thumbImageURL = photoResult.urls.thumb
        let largeImageURL = photoResult.urls.full
        let isLiked = photoResult.likes == 0 ? false : true
        let photo = Photo(id: id, size: size, createdAt: date, welcomeDescription: description, thumbImageURL: thumbImageURL, largeImageURL: largeImageURL, isLiked: isLiked)
        return photo
    }
    
    func dateFromISO8601(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string)
    }
    
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
            assertionFailure("Invalid URLComponents string for OAuth token request")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
