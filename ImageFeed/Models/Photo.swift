//
//  Photo.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/11.
//
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: URL?
    let fullImageURL: URL?
    let isLiked: Bool
}
