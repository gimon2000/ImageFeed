//
//  ImagesListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by gimon on 18.05.2024.
//

import Foundation

public protocol ImagesListViewPresenterProtocol {
    var photos: [Photo] { get set }
    var view: ImagesListViewControllerProtocol? { get set }
    func updatePhotos() -> Range<Int>?
    func getDataCell(with index: Int) -> DataTableCell?
}
