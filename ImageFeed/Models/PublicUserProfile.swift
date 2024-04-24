//
//  PublicUserProfile.swift
//  ImageFeed
//
//  Created by gimon on 20.04.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImageSmall
}

struct ProfileImageSmall: Codable {
    let small: String
}
