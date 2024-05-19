//
//  AlertPresenterSpy.swift
//  Image FeedTests
//
//  Created by gimon on 19.05.2024.
//

import Foundation
import ImageFeed

final class AlertPresenterSpy: AlertPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var alertExitCalled = false
    
    func alertExit() {
        alertExitCalled = true
    }
}
