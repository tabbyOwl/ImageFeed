//
//  Untitled.swift
//  ImageFeed
//
//  Created by Svetlana on 2026/1/3.
//
import Foundation

final class AuthHelperMock: AuthHelperProtocol {
    var authRequestCalled = false
    
    var stubbedRequest: URLRequest? = URLRequest(
        url: URL(string: "https://test.com")!
    )
    
    var authURLRequest: URLRequest? {
        authRequestCalled = true
        return stubbedRequest
    }
    
    
    func getCode(from url: URL) -> String? {
        return "test_code"
    }
}
