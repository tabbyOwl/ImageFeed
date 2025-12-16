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
    private init() {}
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private var decoder = SnakeCaseJSONDecoder()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func clearPhotos() {
        DispatchQueue.main.async {
            self.photos = []
            NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
        }
    }
    
    func fetchPhotosNextPage() {
        if self.task != nil {
            return
        }
        
        guard let token = KeychainWrapper.standard.string(forKey: Constants.oAuthTokenKey) else {
            print("Failed to get token from storage")
            return }
        
        let nextPage = (self.lastLoadedPage ?? 0) + 1
        
        guard let request = self.makePhotosRequest(token: token, page: nextPage) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            
                switch result {
                case .success(let photoResult):
                    let newPhotos: [Photo] = photoResult.map { self.convert(photoResult: $0)}
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: newPhotos)
                        self.lastLoadedPage = nextPage
                        
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self
                        )
                    }
                case .failure(let error):
                    print("[ProfileImageService]: error \(error)")
                }
                self.task = nil
            }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
            let photo = self.photos[index]
            
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                fullImageURL: photo.fullImageURL,
                isLiked: !photo.isLiked
            )
            self.photos[index] = newPhoto
            completion(.success(()))
        }
    }
    
    private func convert(photoResult: PhotoResult) -> Photo {
        let id = photoResult.id
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        let date = dateFromISO8601(photoResult.createdAt)
        let description = photoResult.description
        
        
        let thumbImageURL = URL(string: photoResult.urls.thumb)
        let largeImageURL = URL(string: photoResult.urls.full)
        
    
        let isLiked = photoResult.likedByUser
        let photo = Photo(id: id, size: size, createdAt: date, welcomeDescription: description, thumbImageURL: thumbImageURL, fullImageURL: largeImageURL, isLiked: isLiked)
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
