//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by gimon on 02.04.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let identifierShowWebView = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifierShowWebView {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(identifierShowWebView)")
            }
            print("AuthViewController prepare segue.identifier: \(identifierShowWebView)")
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        print("AuthViewController webViewViewController")
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        delegate?.didAuthenticate(self, code: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
