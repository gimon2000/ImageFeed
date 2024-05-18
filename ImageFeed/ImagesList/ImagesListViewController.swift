//
//  ViewController.swift
//  ImageFeed
//
//  Created by gimon on 29.02.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Public Properties
    var presenter: ImagesListViewPresenterProtocol?
    
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let presenter = self?.presenter else { return }
                print("ImagesListViewController imagesListServiceObserver")
                presenter.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            guard let presenter else {
                print("ImagesListViewController prepare presenter: nil")
                return
            }
            let stringURL = presenter.photos[indexPath.row].largeImageURL
            
            viewController.setStringURLImage(stringURL: stringURL)
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else {
            print("ImagesListViewController UITableViewDataSource numberOfRowsInSection presenter: nil")
            return 0
        }
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        guard let presenter else {
            print("ImagesListViewController UITableViewDataSource cellForRowAt presenter: nil")
            return UITableViewCell()
        }
        presenter.configCell(for: imageListCell, with: indexPath)
        
        let thumbImageURL = presenter.photos[indexPath.row].thumbImageURL
        guard
            let url = URL(string: thumbImageURL),
            let imageView = imageListCell.imageCell
        else { return imageListCell }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage( with: url ){ result in
            switch result {
            case .success(let result):
                print("tableView cellForRowAt setImage success result: \(result)")
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("tableView cellForRowAt setImage failure error: \(error)")
            }
        }
        
        imageListCell.delegate = self
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else {
            print("ImagesListViewController UITableViewDataSource willDisplay presenter: nil")
            return
        }
        if indexPath.row + 1 == presenter.photos.count {
            print("ImagesListViewController UITableViewDataSource UITableViewCell imagesListService.fetchPhotosNextPage()")
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else {
            print("ImagesListViewController UITableViewDelegate heightForRowAt presenter: nil")
            return CGFloat()
        }
        let imageSize = presenter.photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell, completion: @escaping (Bool) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(index: indexPath.row) {[weak self] result in
            
            UIBlockingProgressHUD.dismiss()
            
            guard var presenter = self?.presenter else {
                print("ImagesListViewController ImagesListCellDelegate self: nil")
                return
            }
            
            switch result {
            case .success(let resultBool):
                print("ImagesListViewController ImagesListCellDelegate success: \(resultBool)")
                presenter.photos[indexPath.row].isLiked = resultBool
                completion(resultBool)
            case .failure(let error):
                print("ImagesListViewController ImagesListCellDelegate failure: \(error)")
            }
        }
    }
}
