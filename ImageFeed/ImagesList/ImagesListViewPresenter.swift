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
        formatter.locale = Locale.init(identifier: "RU")
        return formatter
    }()
    
    // MARK: - Public Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if indexPath.row < photos.count {
            guard let image = UIImage(named: "Stub") else {
                return
            }
            var dateString: String
            if let date = photos[indexPath.row].createdAt {
                dateString = dateFormatter.string(from: date)
            } else {
                dateString = ""
            }
            let isLiked = photos[indexPath.row].isLiked
            cell.configImageCell(image: image, dateString: dateString, isLiked: isLiked)
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        print("ImagesListViewPresenter updateTableViewAnimated oldCount: \(oldCount)")
        let newCount = imagesListService.photos.count
        print("ImagesListViewPresenter updateTableViewAnimated newCount: \(newCount)")
        if oldCount != newCount {
            photos = imagesListService.photos
            guard let view else {
                print("ImagesListViewPresenter updateTableViewAnimated view: nil")
                return
            }
            view.tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                view.tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}
