//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by gimon on 07.04.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken, tokenType, scope: String
    let createdAt: Int
}
