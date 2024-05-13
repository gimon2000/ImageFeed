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
    
    //MARK: Public Methods
    func viewDidLoad() {
        guard
            let view,
            var urlComponents = URLComponents(
                string: Constants.unsplashURLString + "/oauth/authorize"
            ) else {
            print("loadAuthView urlComponents error")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("loadAuthView url error")
            return
        }
        
        let request = URLRequest(url: url)
        
        didUpdateProgressValue(0)
        
        view.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        print("WKNavigationDelegate code url: \(url)")
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"}) {
            print("WKNavigationDelegate code", codeItem.value ?? "nil")
            return codeItem.value
        } else {
            return nil
        }
    }
    
    // MARK: Private Methods
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
