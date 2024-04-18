//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by gimon on 13.04.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService()
    private let identifierTabBarViewController = "TabBarViewController"
    private let identifierAuthView = "ShowAuthView"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            UIBlockingProgressHUD.show()
            fetchParamProfile(token)
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
            DispatchQueue.global(qos: .default).sync {
                self.fetchOAuthToken(code)
                guard let token = self.storage.token else { return }
                UIBlockingProgressHUD.show()
                self.fetchParamProfile(token)
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
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

extension SplashViewController {
    
    private func fetchParamProfile(_ token: String){
        profileService.fetchProfile(token){ result in
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let profile):
                print("ProfileViewController fetchParamProfile success: \(profile)")
                self.storage.name = profile.name
                self.storage.loginName = profile.loginName
                self.storage.bio = profile.bio
            case .failure(let error):
                print("ProfileViewController fetchParamProfile failure: \(error)")
                break
            }
        }
    }
}
