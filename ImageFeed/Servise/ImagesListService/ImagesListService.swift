//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/11.
//

import Foundation
import CoreGraphics
import SwiftKeychainWrapper
import Logging

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func clearPhotos()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    
}

final class ImagesListService: ImagesListServiceProtocol {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private static let dateFormatter: ISO8601DateFormatter = {
        ISO8601DateFormatter()
    }()
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private var decoder = SnakeCaseJSONDecoder()
    private let logger = Logger(label: "ImagesListService")
    
    func clearPhotos() {
        DispatchQueue.main.async {
            self.photos = []
            NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
        }
    }
    
    func fetchPhotosNextPage() {
        guard task == nil else {
            return
        }
        
        guard let token = KeychainWrapper.standard.string(forKey: Constants.oAuthTokenKey) else {
            logger.error("Failed to get token from storage", metadata: ["key": "\(Constants.oAuthTokenKey)"])
            return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                let newPhotos: [Photo] = photoResult.map { self.convert(photoResult: $0)}
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
            case .failure(let error):
                self.logger.error("Failed to load photos page \(nextPage)", metadata: ["error": "\(error)", "url": "\(request.url?.absoluteString ?? "unknown")"])
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let token = KeychainWrapper.standard.string(forKey: Constants.oAuthTokenKey) else {
            completion(.failure(NetworkError.invalidToken))
            return
        }

        let request = makeLikeRequest(photoId: photoId, isLike: isLike, token: token)

        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success:
                self?.updateLikeState(photoId: photoId)
                completion(.success(()))

            case .failure(let error):
                self?.logger.error("Failed to change like",
                                   metadata: ["photoId": .string(photoId), "error": "\(error)"])
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    private func convert(photoResult: PhotoResult) -> Photo {
        let id = photoResult.id
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        let date = ImagesListService.dateFormatter.date(from: photoResult.createdAt)
        let description = photoResult.description
        
        
        let thumbImageURL = URL(string: photoResult.urls.thumb)
        let largeImageURL = URL(string: photoResult.urls.full)
        
        
        let isLiked = photoResult.likedByUser
        let photo = Photo(id: id, size: size, createdAt: date, welcomeDescription: description, thumbImageURL: thumbImageURL, fullImageURL: largeImageURL, isLiked: isLiked)
        return photo
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
    
    private func makeLikeRequest(
        photoId: String,
        isLike: Bool,
        token: String
    ) -> URLRequest {
        let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HTTPMethod.delete.rawValue : HTTPMethod.post.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func updateLikeState(photoId: String) {
        guard let index = photos.firstIndex(where: { $0.id == photoId }) else { return }

        let oldPhoto = photos[index]
        photos[index] = Photo(
            id: oldPhoto.id,
            size: oldPhoto.size,
            createdAt: oldPhoto.createdAt,
            welcomeDescription: oldPhoto.welcomeDescription,
            thumbImageURL: oldPhoto.thumbImageURL,
            fullImageURL: oldPhoto.fullImageURL,
            isLiked: !oldPhoto.isLiked
        )
    }
}
