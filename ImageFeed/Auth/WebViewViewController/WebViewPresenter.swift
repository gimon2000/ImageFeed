//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by gimon on 13.05.2024.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: Public Properties
    weak var view: WebViewViewControllerProtocol?
    
    // MARK: Private Properties
    private var authHelper: AuthHelperProtocol
    
    // MARK: Initializers
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    //MARK: Public Methods
    func viewDidLoad() {
        
        guard
            let view,
            let request = authHelper.authRequest() else {
            print("WebViewPresenter viewDidLoad request else")
            return
        }
        
        view.load(request: request)
        
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    // MARK: Private Methods
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
