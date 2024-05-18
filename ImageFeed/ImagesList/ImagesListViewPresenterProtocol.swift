//
//  ImagesListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by gimon on 18.05.2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var photos: [Photo] { get set }
    var view: ImagesListViewControllerProtocol? { get set }
    func updateTableViewAnimated()
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
}
