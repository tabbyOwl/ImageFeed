//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/3.
//

import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
}

final class WebViewViewController: UIViewController {
    weak var delegate: WebViewViewControllerDelegate?
    
    //MARK: - Private properties
    private let progressView = UIProgressView()
    private var webView = WKWebView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBackButton()
        loadAuthView()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.updateProgress()
             })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgress()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupWebView()
        setupProgressView()
        setupConstraints()
        setupBackButton()
    }
    
    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    private func setupProgressView() {
        progressView.progressTintColor = .ypBlack
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
    }
    
    private func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .navBackButton),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
    }
    
    @objc private func didTapBack() {
        dismiss(animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//MARK: -WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel, preferences)
        } else {
            decisionHandler(.allow, preferences)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
