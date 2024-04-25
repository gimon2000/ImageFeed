//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by gimon on 20.04.2024.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private init() {}
    
    private (set) var avatarURL: String?
    
    private var task: URLSessionTask?
    
    private func userUsernameRequest(_ token: String, username: String) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "users/\(username)") else {
            print("ProfileImageService userUsernameRequest url nil")
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("ProfileImageService userUsernameRequest urlRequest: \(urlRequest)")
        return urlRequest
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        
        task?.cancel()
        
        guard let urlRequest = userUsernameRequest(token, username: username) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let response):
                let avatarURL = response.profileImage.small
                self.avatarURL = avatarURL
                print("ProfileImageService fetchProfileImageURL success avatarURL: \(avatarURL)")
                completion(.success(avatarURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL]
                )
                self.task = nil
            case .failure(let error):
                print("ProfileImageService fetchProfileImageURL failure: \(error)")
                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
