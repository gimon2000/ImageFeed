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
    private let profileService = ProfileService.shared
    private let identifierTabBarViewController = "TabBarViewController"
    private let identifierAuthView = "ShowAuthView"
    private var authViewController = AuthViewController()
    
    private let logoImageView: UIImageView = {
        let logoImage = UIImage(named: "SplashScreen")
        let view = UIImageView()
        view.image = logoImage
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        addConstraintLogoImageView()
        
        if let token = storage.token {
            UIBlockingProgressHUD.show()
            fetchParamProfile(token)
            switchToTabBarController()
        } else {
            print("SplashViewController viewDidAppear performSegue: \(identifierAuthView)")
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
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
    
    private func addConstraintLogoImageView(){
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
                self.fetchAvatarProfile(token: token, username: profile.username)
            case .failure(let error):
                print("ProfileViewController fetchParamProfile failure: \(error)")
                break
            }
        }
    }
}

extension SplashViewController {
    private func fetchAvatarProfile(token: String, username: String) {
        ProfileImageService.shared.fetchProfileImageURL(token: token, username: username) { result in
            switch result {
            case .success(let avatarURL):
                print("SplashViewController fetchAvatarProfile avatarURL: \(avatarURL ?? "nil")")
            case .failure(let error):
                print("SplashViewController fetchAvatarProfile failure: \(error)")
                break
            }
        }
    }
}
