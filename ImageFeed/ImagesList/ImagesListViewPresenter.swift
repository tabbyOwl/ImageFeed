//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/24.
//
import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func getPhoto(at index: Int) -> Photo
    
    func handleLikeButtonTap(photo: Photo, indexPath: IndexPath)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    private var photos = [Photo]()
    private var imagesListService: ImagesListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        observeImagesListChanges()
        fetchPhotosNextPage()
    }
    
    var photosCount: Int {
        photos.count
    }

    func getPhoto(at index: Int) -> Photo {
        photos[index]
    }
    
    deinit {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func getPhotos() -> [Photo] {
        return photos
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func handleLikeButtonTap(photo: Photo, indexPath: IndexPath) {
        var hudShown = false
        
        let workItem = DispatchWorkItem {
            hudShown = true
            self.view?.showLoadingHUD()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                workItem.cancel()
                
                if hudShown {
                    self?.view?.hideLoadingHUD()
                }
                
                guard let self else { return }
                switch result {
                case .success:
                    self.view?.reloadRows(indexPaths: [indexPath])
                case .failure:
                    self.view?.showError()
                }
            }
        }
    }
    
    private func observeImagesListChanges() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                updateTableView()
            }
    }
    
    private func updateTableView() {
        let oldCount = photos.count
        let newPhotos = imagesListService.photos
        let newCount = newPhotos.count

        guard newCount > oldCount else { return }

        photos = newPhotos

        if oldCount == 0 {
            view?.reloadData()
        } else {
            view?.insertRows(oldCount: oldCount, newCount: newCount)
        }
    }
}
