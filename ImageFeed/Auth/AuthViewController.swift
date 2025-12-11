//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/3.
//
import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    //MARK: - Private properties
    private var imageView = UIImageView()
    private let enterButton = UIButton()
    private let oauth2Service = OAuth2Service.shared
    
    //MARK: - Public properties
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupBackground()
        setupImage()
        setupEnterButton()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .authScreenLogo)
        view.addSubview(imageView)
    }
    
    private func setupEnterButton() {
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.ypBlack, for: .normal)
        enterButton.titleLabel?.font = Fonts.sfProTextRegular17
        enterButton.layer.cornerRadius = 16
        enterButton.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        enterButton.backgroundColor = .ypWhite
        view.addSubview(enterButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            enterButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @objc private func didTapEnterButton() {
        showWebView()
    }
    
    private func showWebView() {
        let webVC = WebViewViewController()
        webVC.delegate = self
        let navVC = UINavigationController(rootViewController: webVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypBlack
        navVC.navigationBar.standardAppearance = appearance
        present(navVC, animated: true)
    }
    
}
//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        fetchOAuthToken(code) { [weak self] result in
            
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
                
            case .failure:
                self.showAuthErrorAlert()
                break
            }
        }
    }
}

//MARK: - fetchOAuthToken
extension AuthViewController {
    private func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOauthToken(code: code) { result in
            completion(result)
        }
    }
}
