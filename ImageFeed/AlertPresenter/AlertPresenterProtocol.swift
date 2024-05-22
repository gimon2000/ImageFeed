//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by gimon on 19.05.2024.
//

import Foundation

public protocol AlertPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func alertExit()
}
