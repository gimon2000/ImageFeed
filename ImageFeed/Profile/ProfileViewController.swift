//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by gimon on 15.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let avatarImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
    private let nickLabel: UILabel = UILabel()
    private let messageLabel: UILabel = UILabel()
    private var exitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImageAvatar()
        createExitButton()
        createNameLabel()
        createNickLabel()
        createMessageLabel()
    }
    
    private func createImageAvatar(){
        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarImage = UIImage(named: "Photo")
        avatarImageView.image = avatarImage
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func createExitButton(){
        let imageExitButton = UIImage(named: "Exit")
        exitButton = UIButton.systemButton(with: imageExitButton!, target: nil, action: #selector(didClickExitButton))
        guard let exitButton = exitButton else {
            return
        }
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.tintColor = .red
        NSLayoutConstraint.activate([
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func createNameLabel(){
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func createNickLabel(){
        view.addSubview(nickLabel)
        nickLabel.translatesAutoresizingMaskIntoConstraints = false
        nickLabel.text = "@ekaterina_nov"
        nickLabel.textColor = UIColor(red: 174.0 / 255.0, green: 175.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0 )
        nickLabel.font = UIFont.systemFont(ofSize: 13)
        
        NSLayoutConstraint.activate([
            nickLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func createMessageLabel(){
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Hello, world!"
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8)
        ])
    }
    
    @objc private func didClickExitButton(_ sender: Any) {
    }
}
