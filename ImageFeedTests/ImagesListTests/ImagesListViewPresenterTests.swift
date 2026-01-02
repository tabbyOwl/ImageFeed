//
//  ImagesListViewPresenterTests.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/24.
//

import XCTest
@testable import ImageFeed

@MainActor
final class ImagesListViewPresenterTests: XCTestCase {
    private var presenter: ImagesListViewPresenter!
    private var view: ImagesListViewControllerSpy!
    private var service: ImagesListServiceMock!
    
    override func setUp() {
        super.setUp()
        service = ImagesListServiceMock()
        presenter = ImagesListViewPresenter(imagesListService: service)
        view = ImagesListViewControllerSpy()
        presenter.view = view
    }
    
    func testViewDidLoadCallsFetchPhotos() {
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(service.fetchCalled)
    }
    
    
    func testFirstPhotosUpdateCallsReloadData() {
        //given
        let photo = makePhoto(id: "1")
        let secondPhoto = makePhoto(id: "2")
        service.photos = [photo, secondPhoto]
        
        //when
        presenter.viewDidLoad()
        service.sendPhotosUpdate()
        
        //then
        XCTAssertTrue(view.reloadDataCalled)
        XCTAssertEqual(presenter.photosCount, 2)
    }
    
    func testNextPageUpdateCallsInsertRows() {
        //when
        service.photos = [makePhoto(id: "1")]
        presenter.viewDidLoad()
        service.sendPhotosUpdate()
        service.photos.append(makePhoto(id: "2"))
        service.sendPhotosUpdate()
        
        //then
        XCTAssertTrue(view.insertRowsCalled)
        XCTAssertEqual(view.insertedOldCount, 1)
        XCTAssertEqual(view.insertedNewCount, 2)
    }
    
    func testHandleLikeSuccessReloadRowsCalled() {
        //when
        let photo = makePhoto(id: "1")
        service.photos = [photo]
        presenter.viewDidLoad()
        service.sendPhotosUpdate()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let exp = expectation(description: "reload rows")
        presenter.handleLikeButtonTap(photo: photo, indexPath: indexPath)
        
        //then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.reloadRowsCalled)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testHandleLikeFailureShowError() {
        //when
        service.changeLikeResult = .failure(NSError(domain: "", code: 0))
        
        let photo = makePhoto(id: "1")
        service.photos = [photo]
        presenter.viewDidLoad()
        service.sendPhotosUpdate()
        
        presenter.handleLikeButtonTap(photo: photo, indexPath: IndexPath(row: 0, section: 0))
        
        let exp = expectation(description: "error")
        
        //then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.showErrorCalled)
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    private func makePhoto(id: String) -> Photo {
        Photo(
            id: id,
            size: CGSize(width: 100, height: 100),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: nil,
            fullImageURL: nil,
            isLiked: false
        )
    }
}
