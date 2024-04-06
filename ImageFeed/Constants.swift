//
//  Constants.swift
//  ImageFeed
//
//  Created by gimon on 30.03.2024.
//

import Foundation

enum Constants {
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let accessKey = Configuration.value(for: "ACCESS_KEY")
    static let secretKey = Configuration.value(for: "SECRET_KEY")
}

struct Configuration {
    static func value(for key: String) -> String? {
        guard let resultObject = Bundle.main.object(forInfoDictionaryKey: key) else { return nil }
        if let stringObject = resultObject as? String {
            return stringObject
        }
        return nil
    }
}
