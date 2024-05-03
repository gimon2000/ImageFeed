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
        
        UIBlockingProgressHUD.show()
        print("AuthViewController webViewViewController UIBlockingProgressHUD.show()")
        fetchOAuthToken(code, vc: vc)
    }
    
    private func fetchOAuthToken(_ code: String, vc: WebViewViewController) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {
                print("AuthViewController fetchOAuthToken self return")
                return
            }
            vc.navigationController?.popViewController(animated: true)
            UIBlockingProgressHUD.dismiss()
            print("AuthViewController fetchOAuthToken UIBlockingProgressHUD.dismiss()")
            switch result {
            case .success(let success):
                print("SplashViewController fetchOAuthToken success: \(success)")
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print("SplashViewController fetchOAuthToken failure", error)
                present(AlertPresenter.alertError, animated: true )
                break
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
