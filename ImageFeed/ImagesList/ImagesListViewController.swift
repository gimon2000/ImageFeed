//
//  ViewController.swift
//  ImageFeed
//
//  Created by gimon on 29.02.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale.init(identifier: "RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                print("ImagesListViewController imagesListServiceObserver")
                self.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let stringURL = photos[indexPath.row].largeImageURL
            
            viewController.setStringURLImage(stringURL: stringURL)
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if indexPath.row < photos.count {
            guard let image = UIImage(named: "Stub") else {
                return
            }
            var dateString: String
            if let date = photos[indexPath.row].createdAt {
                dateString = dateFormatter.string(from: date)
            } else {
                dateString = ""
            }
            let isLiked = photos[indexPath.row].isLiked
            cell.configImageCell(image: image, dateString: dateString, isLiked: isLiked)
        }
        
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        print("ImagesListViewController updateTableViewAnimated oldCount: \(oldCount)")
        let newCount = imagesListService.photos.count
        print("ImagesListViewController updateTableViewAnimated newCount: \(newCount)")
        if oldCount != newCount {
            photos = imagesListService.photos
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        let thumbImageURL = photos[indexPath.row].thumbImageURL
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
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            print("ImagesListViewController UITableViewDataSource UITableViewCell imagesListService.fetchPhotosNextPage()")
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

