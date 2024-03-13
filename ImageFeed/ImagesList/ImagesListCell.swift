//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by gimon on 10.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
}
