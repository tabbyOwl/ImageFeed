//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/1.
//
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    private let profileImageView = UIImageView()
    private let nameLabel =  UILabel()
    private let loginLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let profile = ProfileService.shared.profile {
            self.updateProfileWith(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    
    // MARK: - Private methods
    private func setupUI() {
        setupBackground()
        setupImageView()
        setupLabel(label: nameLabel, font: Fonts.sfProTextBold23, color: .ypWhite)
        setupLabel(label: loginLabel, font: Fonts.sfProTextRegular13, color: .ypGray)
        setupLabel(label: descriptionLabel, font: Fonts.sfProTextRegular13, color: .ypWhite)
        setupLogoutButton()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(systemName: "person")
        profileImageView.addAnimatedGradient()
        view.addSubview(profileImageView)
    }
    
    private func setupLabel(label: UILabel, font: UIFont?, color: UIColor) {
        label.layer.cornerRadius = 14
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = color
        label.font = font
        label.clipsToBounds = true
        label.addAnimatedGradient()
        view.addSubview(label)
    }
    
    @objc private func setupLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(resource: .exit), for: .normal)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            nameLabel.widthAnchor.constraint(equalToConstant: 238),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginLabel.heightAnchor.constraint(equalToConstant: 28),
            loginLabel.widthAnchor.constraint(equalToConstant: 158),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 128),
            
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        
        print("imageUrl: \(imageUrl)")
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: imageUrl,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                
                switch result {
                case .success(let value):
                    self.profileImageView.removeAnimatedGradient()
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func updateProfileWith(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        
        nameLabel.sizeToFit()
        loginLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        removeAnimatedGradient()
    }
    
    private func updateGradientFrame() {
        nameLabel.updateAnimatedGradientFrame()
        loginLabel.updateAnimatedGradientFrame()
        descriptionLabel.updateAnimatedGradientFrame()
        profileImageView.updateAnimatedGradientFrame()
    }
    
    private func removeAnimatedGradient() {
        nameLabel.removeAnimatedGradient()
        loginLabel.removeAnimatedGradient()
        descriptionLabel.removeAnimatedGradient()
    }
    
    @objc private func didTapLogoutButton() {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            ProfileLogoutService.shared.logout()
            let splachVC = SplashViewController()
            self?.present(splachVC, animated: true)
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true)
    }
}
