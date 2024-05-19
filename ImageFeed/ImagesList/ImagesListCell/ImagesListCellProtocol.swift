//
//  ImagesListCellProtocol.swift
//  ImageFeed
//
//  Created by gimon on 19.05.2024.
//

import UIKit

public protocol ImagesListCellProtocol: UITableViewCell {
    func configImageCell(image: UIImage, dateString: String, isLiked: Bool)
}
