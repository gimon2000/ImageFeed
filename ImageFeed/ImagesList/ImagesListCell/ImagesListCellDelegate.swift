//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by gimon on 09.05.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(
        _ cell: ImagesListCell,
        completion: @escaping (Bool) -> Void
    )
}
