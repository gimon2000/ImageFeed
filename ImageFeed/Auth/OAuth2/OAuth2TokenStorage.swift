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
    
    var name: String? {
        get {
            userDefaults.string(forKey: keys.name.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: keys.name.rawValue)
        }
    }
    
    var loginName: String? {
        get {
            userDefaults.string(forKey: keys.loginName.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: keys.loginName.rawValue)
        }
    }
    
    var bio: String? {
        get {
            userDefaults.string(forKey: keys.bio.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: keys.bio.rawValue)
        }
    }
}
