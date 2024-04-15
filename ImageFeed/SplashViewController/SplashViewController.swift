//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by gimon on 13.04.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    private let identifierTabBarViewController = "TabBarViewController"
    private let identifierAuthView = "ShowAuthView"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = storage.token {
            switchToTabBarController()
        } else {
            print("SplashViewController viewDidAppear performSegue: \(identifierAuthView)")
            performSegue(withIdentifier: identifierAuthView, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("switchToTabBarController Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: identifierTabBarViewController)
        print("switchToTabBarController tabBarController: \(tabBarController.children)")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifierAuthView {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("SplashViewController prepare failed to prepare for \(identifierAuthView)")
            }
            print("SplashViewController prepare segue.identifier: \(identifierAuthView)")
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, code: String) {
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            print("SplashViewController didAuthenticate dismiss")
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            ProgressHUD.dismiss()
            
            switch result {
            case .success(let success):
                print("SplashViewController fetchOAuthToken success: \(success)")
                self.switchToTabBarController()
            case .failure(let error):
                print("SplashViewController fetchOAuthToken failure", error)
                break
            }
        }
    }
}
