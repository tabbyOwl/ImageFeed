//
//  ImagesListServiceMock.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/24.
//
import Foundation

final class ImagesListServiceMock: ImagesListServiceProtocol {
    
    var photos: [Photo] = []
    
    var fetchCalled = false
    var changeLikeCalled = false
    var changeLikeResult: Result<Void, Error> = .success(())
    
    func clearPhotos() {
    }
    
    func fetchPhotosNextPage() {
        fetchCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        changeLikeCalled = true
        completion(changeLikeResult)
    }
    
    func sendPhotosUpdate() {
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
}
