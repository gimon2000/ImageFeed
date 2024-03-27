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
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBAction private func didClickBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func didClickShareButton(_ sender: Any) {
        guard let image = image else {
            return
        }
        let activity = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        present(activity, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage){
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: true)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func setImage (imageView: UIImage) {
        image = imageView
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
