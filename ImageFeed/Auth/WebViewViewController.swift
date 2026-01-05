//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/3.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(_ request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    //MARK: - Private properties
    private let progressView = UIProgressView()
    private var webView = WKWebView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
        setProgressObservation()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }
    
    //MARK: - Public methods
    func load(_ request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
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
        webView.accessibilityIdentifier = AccessibilityIdentifier.Auth.webView
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
    
    private func setProgressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    @objc private func didTapBack() {
        delegate?.webViewViewControllerDidCancel(self)
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
        if let url = navigationAction.request.url
        {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
}
