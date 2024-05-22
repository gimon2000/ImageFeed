//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by gimon on 18.05.2024.
//

import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
}
