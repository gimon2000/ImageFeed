//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by gimon on 09.05.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
    // MARK: - Public Properties
    static let shared = ProfileLogoutService()
    
    // MARK: - Private Properties
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    // MARK: - Initializers
    private init() { }
    
    // MARK: - Public methods
    func logout() {
        cleanCookies()
        oAuth2TokenStorage.removeToken()
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanAvatarURL()
        ImagesListService.shared.cleanPhotos()
    }
    
    // MARK: - Private Methods
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
