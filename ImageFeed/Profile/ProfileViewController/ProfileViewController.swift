//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by gimon on 15.03.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    // MARK: - Public Properties
    var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Private Properties
    private var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Initializers
    init(alertPresenter: AlertPresenterProtocol) {
        self.alertPresenter = alertPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ProfileViewController init(coder:) has not been implemented")
    }
    
    // MARK: - Visual Components
    private let avatarImageView: UIImageView = {
        let avatarImage = UIImage(named: "Photo")
        let view = UIImageView()
        view.image = avatarImage
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 35
        view.accessibilityIdentifier = "avatar image"
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "Екатерина Новикова"
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 23)
        return view
    }()
    
    private let nickLabel: UILabel = {
        let view = UILabel()
        view.text = "@ekaterina_nov"
        view.textColor = UIColor(red: 174.0 / 255.0, green: 175.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0 )
        view.font = UIFont.systemFont(ofSize: 13)
        return view
    }()
    
    private let messageLabel: UILabel = {
        let view = UILabel()
        view.text = "Hello, world!"
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 13)
        return view
    }()
    
    private var exitButton: UIButton = {
        let image = UIImage(named: "Exit")
        guard let image = image else {
            return UIButton()
        }
        let view = UIButton.systemButton(with: image, target: nil, action: #selector(didClickExitButton))
        view.tintColor = .red
        view.accessibilityIdentifier = "logout button"
        return view
    }()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard var alertPresenter else {
            print("ProfileViewController viewDidLoad alertPresenter: nil")
            return
        }
        alertPresenter.view = self
        
        view.backgroundColor = .ypBlack
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        [avatarImageView,
         nameLabel,
         nickLabel,
         messageLabel,
         exitButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        addConstraintImageAvatar()
        addConstraintExitButton()
        addConstraintNameLabel()
        addConstraintNickLabel()
        addConstraintMessageLabel()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    // MARK: - Private Methods
    private func addConstraintImageAvatar(){
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func addConstraintExitButton(){
        NSLayoutConstraint.activate([
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func addConstraintNameLabel(){
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func addConstraintNickLabel(){
        NSLayoutConstraint.activate([
            nickLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func addConstraintMessageLabel(){
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        nickLabel.text = profile.loginName
        messageLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let avatarURLString = ProfileImageService.shared.avatarURL,
            let url = URL(string: avatarURLString)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.setImage(
            with: url,
            options: [.processor(processor)])
    }
    
    @objc func didClickExitButton(_ sender: Any) {
        guard let alertPresenter else {
            print("ProfileViewController didClickExitButton alertPresenter: nil")
            return
        }
        alertPresenter.alertExit()
    }
    
    func confirmExit() {
        ProfileLogoutService.shared.logout()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("confirmExit Invalid Configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
}
