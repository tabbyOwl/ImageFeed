//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Svetlana on 2025/12/11.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: service,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 60)
        
        XCTAssertEqual(service.photos.count, 10)
       
    }
    
}
