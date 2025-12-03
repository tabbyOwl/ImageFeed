//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/1.
//
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setupImageView()
        setupNameLabel()
        setupLoginLabel()
        setupDescriptionLabel()
        setupLogoutButton()
        setupConstraints()
    }
    
    // MARK: - Private methods
    private func setupImageView() {
        profileImageView = UIImageView()
        guard let profileImageView else { return }
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(resource: .avatar)
        view.addSubview(profileImageView)
    }
    
    private func setupNameLabel() {
        nameLabel = UILabel()
        guard let nameLabel else { return }
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.text = "Екатерина Новикова"
        view.addSubview(nameLabel)
    }
        
    private func setupLoginLabel() {
        loginLabel = UILabel()
        guard let loginLabel else { return }
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.textColor = .ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.text = "@ekaterina.nov"
        view.addSubview(loginLabel)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel = UILabel()
        guard let descriptionLabel else { return }
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.text = "Hello, world!"
        view.addSubview(descriptionLabel)
    }
    
    @objc private func setupLogoutButton() {
        logoutButton = UIButton()
        guard let logoutButton else { return }
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(resource: .exit), for: .normal)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        
        guard let profileImageView,
              let nameLabel,
              let loginLabel,
              let descriptionLabel,
              let logoutButton else { return }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapLogoutButton() {
        print("Logout button tapped")
    }
}
