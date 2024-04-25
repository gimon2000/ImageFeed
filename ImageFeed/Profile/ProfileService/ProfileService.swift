//
//  ProfileService.swift
//  ImageFeed
//
//  Created by gimon on 17.04.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private init() {}
    
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    private func meRequest(_ token: String) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "me") else {
            print("ProfileService meRequest url nil")
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("ProfileService meRequest urlRequest: \(urlRequest)")
        return urlRequest
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        guard let urlRequest = meRequest(token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest){ (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let response):
                let lastName = response.lastName ?? ""
                let bio = response.bio ?? ""
                let profile = Profile(
                    username: response.username,
                    name: [response.firstName, lastName].joined(separator: " "),
                    loginName: "@" + response.username,
                    bio: bio)
                self.profile = profile
                print("ProfileService fetchProfile task success profile: \(profile)")
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                print("ProfileService fetchProfile failure: \(error)")
                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
