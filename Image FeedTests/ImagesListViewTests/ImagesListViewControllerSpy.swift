//
//  ImagesListViewControllerSpy.swift
//  Image FeedTests
//
//  Created by gimon on 19.05.2024.
//

import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    var updateTableViewCalled = false
    var configCellCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewCalled = true
    }
    
    func configCell(for cell: ImageFeed.ImagesListCellProtocol, image: UIImage, dateString: String, isLiked: Bool) {
        configCellCalled = true
    }
}
