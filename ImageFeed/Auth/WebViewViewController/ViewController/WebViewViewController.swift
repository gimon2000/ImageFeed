//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by gimon on 02.04.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    // MARK: IBOutlet
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: Public Properties
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: Override Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
        
        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    // MARK: Public Methods
    func load(request: URLRequest){
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.setProgress(newValue, animated: true)
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

extension WebViewViewController: WKNavigationDelegate {
    // MARK: Public Methods
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    // MARK: Private Methods
    private func code(from navigationAction: WKNavigationAction) -> String? {
        print("WKNavigationDelegate code url", navigationAction.request.url ?? "nil")
        if
            let presenter,
            let url = navigationAction.request.url {
            return presenter.code(from: url)
        } else {
            return nil
        }
    }
}
