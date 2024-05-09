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
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("ImagesListCell prepareForReuse imageCell.kf.cancelDownloadTask")
        imageCell.kf.cancelDownloadTask()
    }
    
    @IBAction func clickLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self) {[weak self] isLiked in
            guard let self = self else {
                print("ImagesListCell clickLikeButton self: nil")
                return
            }
            self.setImageLike(isLiked: isLiked)
        }
    }
    
    func configImageCell(image: UIImage, dateString: String, isLiked: Bool) {
        imageCell.image = image
        dateLabel.text = dateString
        setImageLike(isLiked: isLiked)
    }
    
    private func setImageLike(isLiked: Bool) {
        guard let imageLike = UIImage(named: isLiked ? "Active" : "No Active") else {
            return
        }
        likeButton.setImage(imageLike, for: UIControl.State.normal)
    }
}
