//
//  WebViewPresenterSpy.swift
//  Image FeedTests
//
//  Created by gimon on 14.05.2024.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    // MARK: Public Properties
    var view: ImageFeed.WebViewViewControllerProtocol?
    var viewDidLoadCalled = false
    
    // MARK: Public Methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        nil
    }
}
