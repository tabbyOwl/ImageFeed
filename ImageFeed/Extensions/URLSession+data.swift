//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import UIKit
import Logging

extension URLSession {
    
    private static let logger = Logger(label: "URLSession")
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            
            if let error = error {
                URLSession.logger.error("URLSession error",metadata: ["error": "\(error)"])
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard let response = response,
                  let httpResponse = response as? HTTPURLResponse else {
                URLSession.logger.error("Invalid response (not HTTPURLResponse)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.invalidResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            if !(200..<300).contains(statusCode) {
                URLSession.logger.warning("HTTP error", metadata: ["statusCode": "\(httpResponse.statusCode)"])
                fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                return
            }
            
            guard let data = data else {
                URLSession.logger.error("Empty response data")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                return
            }
            
            fulfillCompletionOnTheMainThread(.success(data))
        }
        
        return task
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = SnakeCaseJSONDecoder()
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    URLSession.logger.error("Decoding failed", metadata: ["type": "\(T.self)","error": "\(error)"])
                    completion(.failure(error))
                }
            case .failure(let error):
                URLSession.logger.error("objectTask failed", metadata: ["error": "\(error)", "request": "\(request.url?.absoluteString ?? "unknown")"])
                completion(.failure(error))
            }
        }
        return task
    }
}


