//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by gimon on 06.05.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width, height: Double
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let regular, thumb: String
}
