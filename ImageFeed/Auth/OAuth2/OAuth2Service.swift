//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by gimon on 06.04.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(
            string: Constants.unsplashURLString + "/oauth/token"
        ) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        print("makeOAuthTokenRequest urlRequest", urlRequest)
        
        return urlRequest
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("fetchOAuthToken lastCode = code: \(code)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        lastCode = code
        
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(for: urlRequest){ result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.oAuth2TokenStorage.token = response.accessToken
                    print("fetchOAuthToken success response: \(response)")
                    completion(.success(response.accessToken))
                    self.task = nil
                    self.lastCode = nil
                } catch {
                    print("fetchOAuthToken catch: \(String(data: data, encoding: .utf8) ?? "nil")")
                    completion(.failure(error))
                    self.task = nil
                    self.lastCode = nil
                }
            case .failure(let error):
                print("fetchOAuthToken failure: \(error)")
                completion(.failure(error))
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
