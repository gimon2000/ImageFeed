//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by gimon on 17.03.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    private var image = UIImage(named: "StubSingle")
    private var stringURL: String?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
            imageView.image = image
            guard
                let stringURL = stringURL,
                let url = URL(string: stringURL)
            else {
                print("SingleImageViewController viewDidLoad image url or stringURL: nil")
                return
            }
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage( with: url) { [weak self] result in
                guard let self = self else {
                    print("SingleImageViewController viewDidLoad imageView.kf.setImage self: nil")
                    return
                }
                switch result{
                case .success(let result):
                    print("SingleImageViewController viewDidLoad imageView.kf.setImage success result: \(result)")
                    let image = result.image
                    self.image = image
                    self.rescaleAndCenterImageInScrollView(image: image)
                case .failure(let error):
                    print("SingleImageViewController viewDidLoad imageView.kf.setImage failure error: \(error)")
                }
            }
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
    
    func setStringURLImage(stringURL: String) {
        self.stringURL = stringURL
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
