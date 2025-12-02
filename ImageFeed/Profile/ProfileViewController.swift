//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/1.
//
import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var loginNameLabel: UILabel!
    
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var logoutButton: UIButton!
    
    @IBAction private func didTapLogoutButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.setTitle("", for: .normal)
    }
}
