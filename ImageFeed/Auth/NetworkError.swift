//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
    case invalidResponse
    case invalidToken
}
