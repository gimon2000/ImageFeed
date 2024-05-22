//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by gimon on 30.03.2024.
//

import Foundation

enum Constants {
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let unsplashURLString = "https://unsplash.com"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let defaultBaseURLString = "https://api.unsplash.com/"
    static let accessKey = "3JXueAi0D_RVCMj8w7Fhw87MRkarn9ohTBK89Btsexo"
    static let secretKey = "RbvSntGTK80JD24sgkLZ4gJKmByaZjspuFYDLlh-n9U"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let unsplashURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURLString: String, unsplashURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.unsplashURLString = unsplashURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURLString: Constants.defaultBaseURLString,
            unsplashURLString: Constants.unsplashURLString
        )
    }
}
