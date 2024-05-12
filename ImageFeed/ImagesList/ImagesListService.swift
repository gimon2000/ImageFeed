//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by gimon on 06.05.2024.
//

import Foundation

final class ImagesListService {
    // MARK: - Constants
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Private Properties
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    // MARK: - Public methods
    func cleanPhotos() {
        photos = []
    }
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let urlRequest = photosRequest(page: nextPage) else {
            print("ImagesListService fetchPhotosNextPage urlRequest nil")
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<[PhotoResult],Error>) in
            guard let self else {
                print("ImagesListService fetchPhotosNextPage URLSession.shared.objectTask self: nil")
                return
            }
            switch result {
            case .success(let response):
                var photosResponse: [Photo] = []
                response.forEach { photoResponse in
                    let photo: Photo = Photo(
                        id: photoResponse.id,
                        size: CGSize(
                            width: photoResponse.width,
                            height: photoResponse.height),
                        createdAt: self.getDateFromString(dateString: photoResponse.createdAt),
                        welcomeDescription: photoResponse.description,
                        thumbImageURL: photoResponse.urls.thumb,
                        largeImageURL: photoResponse.urls.full,
                        isLiked: photoResponse.likedByUser
                    )
                    photosResponse.append(photo)
                }
                print("ImagesListService fetchPhotosNextPage result success photos: \(photosResponse)")
                DispatchQueue.main.async {
                    self.photos += photosResponse
                    self.lastLoadedPage = nextPage
                    self.task = nil
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )
                }
            case .failure(let error):
                print("ImagesListService fetchPhotosNextPage result failure: \(error)")
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(index: Int, _ completion: @escaping (Result<Bool, Error>) -> Void){
        guard var urlRequest = likeRequest(photoId: photos[index].id) else {
            print("ImagesListService changeLike urlRequest nil")
            return
        }
        urlRequest.httpMethod = photos[index].isLiked ? "DELETE" : "POST"
        
        let task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<LikeResult,Error>) in
            guard let self else {
                print("ImagesListService changeLike URLSession.shared.objectTask self: nil")
                completion(.failure(NetworkError.invalidRequest))
                return
            }
            
            switch result {
            case .success(let response):
                print("ImagesListService changeLike result success: \(response)")
                DispatchQueue.main.async {
                    completion(.success(response.photo.likedByUser))
                    self.photos[index].isLiked = response.photo.likedByUser
                }
            case .failure(let error):
                print("ImagesListService changeLike result failure: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Private methods
    private func photosRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "photos?page=\(page)"),
              let token = OAuth2TokenStorage().token else {
            print("ImagesListService photosRequest url nil")
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("ImagesListService photosRequest urlRequest: \(urlRequest)")
        return urlRequest
    }
    
    private func getDateFromString(dateString: String?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let dateString = dateString else {
            return nil
        }
        return formatter.date(from: dateString)
    }
    
    private func likeRequest(photoId: String) -> URLRequest? {
        guard
            let url = URL(string: Constants.defaultBaseURLString + "photos/\(photoId)/like"),
            let token = OAuth2TokenStorage().token else {
            print("ImagesListService postLikeRequest url nil")
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("ImagesListService photosRequest urlRequest: \(urlRequest)")
        return urlRequest
    }
}
