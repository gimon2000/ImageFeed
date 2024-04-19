//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by gimon on 11.04.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    private enum keys: String {
        case token
        case name
        case loginName
        case bio
    }
    
    var token: String? {
        get {
            userDefaults.string(forKey: keys.token.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: keys.token.rawValue)
        }
    }
}
