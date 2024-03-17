//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by gimon on 17.03.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    private var image: UIImage?
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction private func didClickButtonBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setImage (imageView: UIImage) {
        image = imageView
    }
}
