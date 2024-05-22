//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by gimon on 18.05.2024.
//

import UIKit

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService.shared
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    // MARK: - Public Methods
    func getDataCell(with index: Int) -> DataTableCell? {
        if index < photos.count {
            guard let image = UIImage(named: "Stub") else {
                return nil
            }
            var dateString: String
            if let date = photos[index].createdAt {
                dateString = dateFormatter.string(from: date)
            } else {
                dateString = ""
            }
            let isLiked = photos[index].isLiked
            return DataTableCell(image: image, dateString: dateString, isLiked: isLiked)
        }
        return nil
    }
    
    func updatePhotos() -> Range<Int>? {
        let oldCount = photos.count
        print("ImagesListViewPresenter updateTableViewAnimated oldCount: \(oldCount)")
        let newCount = imagesListService.photos.count
        print("ImagesListViewPresenter updateTableViewAnimated newCount: \(newCount)")
        if oldCount != newCount {
            photos = imagesListService.photos
            return oldCount..<newCount
        }
        return nil
    }
}
