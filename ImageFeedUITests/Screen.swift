//
//  Screen.swift
//  ImageFeed
//
//  Created by Svetlana on 2026/1/5.
//
import ImageFeed
import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct AuthScreen: Screen {
    let app: XCUIApplication

    func tapLogin() -> WebAuthScreen {
        app.buttons[AccessibilityIdentifier.Auth.enterButton].tap()
        return WebAuthScreen(app: app)
    }
}

struct WebAuthScreen: Screen {
    let app: XCUIApplication

    private var webView: XCUIElement {
        app.webViews[AccessibilityIdentifier.Auth.webView]
    }

    func waitForLoad() -> Self {
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        return self
    }

    func typeLogin(_ login: String) -> Self {
        let loginField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginField.waitForExistence(timeout: 15))
        loginField.tap()
        loginField.typeText(login)
        webView.swipeUp()
        return self
    }

    func typePassword(_ password: String) -> Self {
        let passwordField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText(password)
        webView.swipeUp()
        return self
    }

    func submit() -> FeedScreen {
        webView.buttons["Login"].tap()
        return FeedScreen(app: app)
    }
}

struct FeedScreen: Screen {
    let app: XCUIApplication

    private var table: XCUIElement {
        app.tables.element
    }

    func waitForFeed() -> Self {
        let firstCell = table.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 25))
        return self
    }

    func scrollFeed() -> Self {
        table.cells.element(boundBy: 0).swipeUp()
        return self
    }

    func likeImage(at index: Int) -> Self {
        let cell = table.cells.element(boundBy: index)
        cell.buttons[AccessibilityIdentifier.ImageList.likeButtonNonActive].tap()
        return self
    }

    func unlikeImage(at index: Int) -> Self {
        let cell = table.cells.element(boundBy: index)
        cell.buttons[AccessibilityIdentifier.ImageList.likeButtonActive].tap()
        return self
    }

    func openImage(at index: Int) -> SingleImageScreen {
        table.cells.element(boundBy: index).tap()
        return SingleImageScreen(app: app)
    }
}

struct SingleImageScreen: Screen {
    let app: XCUIApplication

    func verifyImage() -> Self {
        let image = app.images[AccessibilityIdentifier.SingleImage.imageView]
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        return self
    }

    func zoomInAndOut() -> Self {
        let image = app.images[AccessibilityIdentifier.SingleImage.imageView]
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        return self
    }

    func goBack() -> FeedScreen {
        app.navigationBars.buttons["Back"].tap()
        return FeedScreen(app: app)
    }
}

struct ProfileScreen: Screen {
    let app: XCUIApplication

    func verifyProfile() -> Self {
        XCTAssertTrue(app.staticTexts["Lastname"].exists)
        XCTAssertTrue(app.staticTexts["Login"].exists)
        return self
    }

    func logout() -> AuthScreen {
        app.buttons[AccessibilityIdentifier.Profile.logoutButton].tap()
        return AuthScreen(app: app)
    }
}


