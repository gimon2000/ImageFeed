//
//  meResponseBody.swift
//  ImageFeed
//
//  Created by gimon on 17.04.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username, firstName: String
    let lastName, bio: String?
}
