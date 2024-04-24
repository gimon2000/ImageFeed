//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by gimon on 15.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileService: ProfileService?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let avatarImageView: UIImageView = {
        let avatarImage = UIImage(named: "Photo")
        let view = UIImageView()
        view.image = avatarImage
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
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = ProfileService.shared.profile {
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
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
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
        // TODO: Обновить аватар, используя Kingfisher
    }
    
    @objc private func didClickExitButton(_ sender: Any) {
        // TODO: - Добавить логику перехода по нажатию на кнопки Exit
    }
}
