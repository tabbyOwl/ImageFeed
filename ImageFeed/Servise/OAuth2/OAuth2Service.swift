//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import UIKit
import Logging

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private let storage = OAuth2TokenStorage.shared
    private let decoder = SnakeCaseJSONDecoder()
    
    private let logger = Logger(label: "OAuth2Service")
    private var urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOauthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            logger.warning("Duplicate OAuth code request: \(code)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            logger.error("Failed to create URLRequest with code: \(code)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self]
            (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let body):
                self?.storage.token = body.accessToken
                self?.lastCode = nil
                self?.task = nil
                completion(.success(body.accessToken))
                
            case .failure(let error):
                self?.logger.error("Failed to fetch OAuth token",
                                   metadata: [
                                    "error": "\(error)",
                                    "code": .string(code),
                                    "url": "\(request.url?.absoluteString ?? "unknown")"
                                   ]
                )
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            assertionFailure("Invalid URLComponents string for OAuth token request")
            logger.critical("Invalid URLComponents string for OAuth token request")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            assertionFailure("Failed to create URL from URLComponents")
            logger.critical("Failed to create URL from URLComponents", metadata: ["components": "\(urlComponents)"])
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
}
