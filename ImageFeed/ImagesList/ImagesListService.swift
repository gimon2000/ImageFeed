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
    func fetchPhotosNextPage() {
        if task != nil { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let urlRequest = photosRequest(page: nextPage) else {
            print("ImagesListService fetchPhotosNextPage urlRequest nil")
            //            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest) { [weak self] (result: Result<[PhotoResult],Error>) in
            guard let self = self else {
                print("ImagesListService fetchPhotosNextPage URLSession.shared.objectTask self: nil")
                return
            }
            switch result {
            case .success(let response):
                var photos: [Photo] = []
                response.forEach { photoResponse in
                    let photo: Photo = Photo(
                        id: photoResponse.id,
                        size: CGSize(
                            width: photoResponse.width,
                            height: photoResponse.height),
                        createdAt: photoResponse.createdAt,
                        welcomeDescription: photoResponse.description,
                        thumbImageURL: photoResponse.urls.thumb,
                        largeImageURL: photoResponse.urls.regular,
                        isLiked: photoResponse.likedByUser
                    )
                    photos.append(photo)
                }
                print("ImagesListService fetchPhotosNextPage result success photos: \(photos)")
                DispatchQueue.main.sync {
                    self.photos += photos
                    self.lastLoadedPage = nextPage
                    ImagesListService.didChangeNotification
                }
                //                completion(.success(photos))
            case .failure(let error):
                print("ImagesListService fetchPhotosNextPage result failure: \(error)")
                //                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func photosRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: Constants.defaultBaseURLString + "/photos?page=\(page)") else {
            print("ImagesListService photosRequest url nil")
            return nil
        }
        let urlRequest = URLRequest(url: url)
        print("ImagesListService photosRequest urlRequest: \(urlRequest)")
        return urlRequest
    }
    
}
