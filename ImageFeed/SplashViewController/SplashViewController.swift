//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/4.
//
import UIKit
import Logging

protocol SplashViewControllerProtocol: AnyObject {
    var presenter: SplashViewPresenterProtocol? { get set }
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
}

final class SplashViewController: UIViewController, SplashViewControllerProtocol {
    var presenter: SplashViewPresenterProtocol?
    
    //MARK: - Private properties
    private var imageView = UIImageView()
    private let logger = Logger(label: "SplashViewController")
    
    //MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        presenter?.viewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - Public methods
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showError(_ error: any Error) {
        logger.error("Failed to load profile info",metadata: [ "error": .string("\(error)")])
    }

    //MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .ypBlack
        setupImage()
        setupConstraints()
    }
    
    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .vector)
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.heightAnchor.constraint(equalToConstant: 77)
        ])
    }
}
