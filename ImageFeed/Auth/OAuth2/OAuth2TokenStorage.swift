//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by gimon on 11.04.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private enum keys: String {
        case tokenUnsplash
    }
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: keys.tokenUnsplash.rawValue)
        }
        
        set {
            if let newTokenUnsplash = newValue {
                let isSuccess = KeychainWrapper.standard.set(newTokenUnsplash, forKey: keys.tokenUnsplash.rawValue)
                guard isSuccess else {
                    print("OAuth2TokenStorage token error set isSuccess: \(isSuccess)")
                    return
                }
            }
        }
    }
}
