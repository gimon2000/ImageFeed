//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by gimon on 13.05.2024.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    
    // MARK: - Private Properties
    private let configuration: AuthConfiguration
    
    // MARK: - Initializers
    init(configuration: AuthConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Public Methods
    func authRequest() -> URLRequest? {
        guard let url = authURL() else {
            print("AuthHelper authRequest url error")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        print("AuthHelper code url: \(url)")
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"}) {
            print("AuthHelper code", codeItem.value ?? "nil")
            return codeItem.value
        } else {
            return nil
        }
    }
    
    // MARK: Private Methods
    private func authURL() -> URL? {
        guard var urlComponents = URLComponents(
            string: configuration.unsplashURLString + "/oauth/authorize"
        ) else {
            print("AuthHelper authURL urlComponents error")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
}
