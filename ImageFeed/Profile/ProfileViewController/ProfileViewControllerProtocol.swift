//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by gimon on 19.05.2024.
//

import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var alertPresenter: AlertPresenterProtocol? { get set }
    func confirmExit()
}
