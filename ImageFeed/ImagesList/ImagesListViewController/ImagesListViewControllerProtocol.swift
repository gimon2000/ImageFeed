//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by gimon on 18.05.2024.
//

import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func configCell(for cell: ImagesListCellProtocol, image: UIImage, dateString: String, isLiked: Bool)
}
