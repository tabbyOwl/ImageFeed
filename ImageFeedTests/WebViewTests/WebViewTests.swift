//
//  WebViewTests.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/20.
//
@testable import ImageFeed
import XCTest

@MainActor
final class WebViewTests: XCTestCase {
    
    var view: WebViewViewController!
    var presenter: WebViewPresenter!
    var authHelper: AuthHelperMock!
    
    var viewSpy: WebViewViewControllerSpy!
    var presenterSpy: WebViewPresenterSpy!
    
    let configuration = AuthConfiguration.standard
    
    override func setUp() {
        super.setUp()
        view = WebViewViewController()
        authHelper = AuthHelperMock()
        presenterSpy = WebViewPresenterSpy()
       
        view.presenter = presenterSpy
        presenterSpy.view = view
        
        viewSpy = WebViewViewControllerSpy()
        presenter = WebViewPresenter(authHelper: authHelper)
        viewSpy.presenter = presenter
        presenter.view = viewSpy
    }
    
    override func tearDown() {
        presenter = nil
        authHelper = nil
        view = nil
        viewSpy = nil
        presenterSpy = nil
        super.tearDown()
    }
    
    func testViewControllerCallsViewDidLoad() {
        //when
        _ = view.view
        
        //then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
 
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewSpy.loadRequestCalled)
        XCTAssertTrue(authHelper.authRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.createAuthURL()
        
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.getCode(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }

    
}
