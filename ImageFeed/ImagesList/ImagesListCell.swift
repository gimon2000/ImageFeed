//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by gimon on 10.03.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("ImagesListCell prepareForReuse imageCell.kf.cancelDownloadTask")
        imageCell.kf.cancelDownloadTask()
    }
    
    func configImageCell(image: UIImage, dateString: String, isLiked: Bool) {
        guard let imageLike = UIImage(named: isLiked ? "Active" : "No Active") else {
            return
        }
        imageCell.image = image
        dateLabel.text = dateString
        likeButton.setImage(imageLike, for: UIControl.State.normal)
    }
}
