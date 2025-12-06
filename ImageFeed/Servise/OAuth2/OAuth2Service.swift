//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private let storage = OAuth2TokenStorage.shared
    private let decoder = SnakeCaseJSONDecoder()
    
    private var urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetch(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Failed to create URLRequest with code: \(code)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("URLSession error: \(error.localizedDescription)")
                    completion(.failure(NetworkError.urlRequestError(error)))
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                    print("HTTP Error: Status code \(response.statusCode) from Unsplash")
                    completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    return
                }
                
                guard let data = data else {
                    print("No data returned from the request")
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }
                
                do {
                    guard let self = self else {
                        completion(.failure(NetworkError.invalidRequest))
                        return
                    }
                    let tokenResponse = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.storage.token = tokenResponse.accessToken
                    
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            assertionFailure("Invalid URLComponents string for OAuth token request")
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
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
}
