//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/20.
//

import Foundation

protocol AuthHelperProtocol {
    var authURLRequest: URLRequest? { get }
    func getCode(from url: URL) -> String?
    
}

final class AuthHelper: AuthHelperProtocol {
    var authURLRequest: URLRequest? {
       guard let url = createAuthURL() else { return nil }
       return URLRequest(url: url)
    }
    
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func createAuthURL() -> URL? {
        guard
            var urlComponents = URLComponents(string: configuration.authURLString)
        else {
            assertionFailure("Invalid authorization URL string: \(configuration.authURLString)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
    
    func getCode(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
