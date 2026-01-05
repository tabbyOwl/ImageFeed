//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Svetlana on 2025/12/28.
//
import ImageFeed
import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() {
        AuthScreen(app: app)
            .tapLogin()
            .waitForLoad()
            .typeLogin("")
            .typePassword("")
            .submit()
            .waitForFeed()
    }
    
    func testFeed() {
        FeedScreen(app: app)
            .waitForFeed()
            .scrollFeed()
            .likeImage(at: 3)
            .unlikeImage(at: 3)
            .openImage(at: 1)
            .verifyImage()
            .zoomInAndOut()
            .goBack()
    }
    
    func testProfile() {
        FeedScreen(app: app)
            .waitForFeed()
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        ProfileScreen(app: app)
            .verifyProfile()
            .logout()
    }
}
