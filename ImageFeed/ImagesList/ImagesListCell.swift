//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by gimon on 10.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale.init(identifier: "RU")
        return formatter
    }()
    
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    func configImageCell(imageName: String, index: Int) {
        guard let image = UIImage(named: imageName),
        let imageActiveLike = UIImage(named: "Active"),
        let imageNoActiveLike = UIImage(named: "No Active") else {
            return
        }
        imageCell.image = image
        let date = Date()
        dateLabel.text = dateFormatter.string(from: date)
        if index % 2 == 0 {
            likeButton.setImage(imageActiveLike, for: UIControl.State.normal)
        } else {
            likeButton.setImage(imageNoActiveLike, for: UIControl.State.normal)
        }
    }
}
