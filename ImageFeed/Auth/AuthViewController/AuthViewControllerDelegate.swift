//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by gimon on 13.04.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
