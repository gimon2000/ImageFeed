//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by gimon on 17.03.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    private var stringURL: String?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setImage()
    }
    
    func setStringURLImage(stringURL: String) {
        self.stringURL = stringURL
    }
    
    @IBAction private func didClickBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func didClickShareButton(_ sender: Any) {
        guard let image = imageView.image else {
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
    
    private func setImage() {
        guard
            let stringURL = stringURL,
            let url = URL(string: stringURL)
        else {
            print("SingleImageViewController viewDidLoad image url or stringURL: nil")
            self.showError()
            return
        }
        UIBlockingProgressHUD.show()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage( with: url ) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {
                print("SingleImageViewController viewDidLoad imageView.kf.setImage self: nil")
                return
            }
            switch result{
            case .success(let result):
                print("SingleImageViewController viewDidLoad imageView.kf.setImage success result: \(result)")
                let image = result.image
                self.rescaleAndCenterImageInScrollView(image: image)
            case .failure(let error):
                print("SingleImageViewController viewDidLoad imageView.kf.setImage failure error: \(error)")
                
                if let stub = UIImage(named: "StubSingle") {
                    self.imageView.image = stub
                    self.rescaleAndCenterImageInScrollView(image: stub)
                }
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так.",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "Не надо",
            style: .default){ _ in alert.dismiss(animated: true)
            }
        let action2 = UIAlertAction(
            title: "Повторить",
            style: .default){[weak self] _ in
                guard let self = self else {
                    return
                }
                self.setImage()
            }
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true )
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
