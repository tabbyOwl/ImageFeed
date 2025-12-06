//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/5.
//
import Foundation

nonisolated
final class SnakeCaseJSONDecoder: JSONDecoder, @unchecked Sendable {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
