//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/1.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Private properties
    private let scrollView = UIScrollView()
    private let backButton = UIButton()
    private let imageView = UIImageView()
    private let shareButton = UIButton()
    
    // MARK: - Public properties
    var url: URL?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
    }
    // MARK: - Private methods
    private func setupUI() {
        setupScrollView()
        setupImageView()
        setupBackButton()
        setupShareButton()
        setupConstraints()
    }
    
    private func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bouncesZoom = true
        view.addSubview(scrollView)
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.frame = .zero
        scrollView.addSubview(imageView)
    }
    
    private func setupShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(resource: .sharing), for: .normal)
        shareButton.backgroundColor = .ypBlack
        shareButton.clipsToBounds = true
        shareButton.layer.cornerRadius = 25
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        shareButton.setTitle("", for: .normal)
        view.addSubview(shareButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17)
        ])
    }
    
    private func rescaleAndCenterImage() {
        view.layoutIfNeeded()
        
        let scrollSize = scrollView.bounds.size
        let imageSize = imageView.bounds.size
        
        let widthScale = scrollSize.width / imageSize.width
        let heightScale = scrollSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = max(minScale * 3, 1.0)
        scrollView.zoomScale = minScale
        
        centerImage()
    }
    
    private func centerImage() {
        let scrollSize = scrollView.bounds.size
        let imageFrame = imageView.frame
        
        let horizontalInset = max(0, (scrollSize.width - imageFrame.width) / 2)
        let verticalInset = max(0, (scrollSize.height - imageFrame.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
    
    private func configureFor(image: UIImage) {
        imageView.image = image
        
        imageView.frame = CGRect(origin: .zero, size: image.size)
        scrollView.contentSize = image.size
        
        rescaleAndCenterImage()
    }
    
    private func loadImage() {
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let result):
                configureFor(image: result.image)
            case .failure:
                showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать еще раз?",
            preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Не надо", style: .cancel)
        
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        }
        alert.addAction(noAction)
        alert.addAction(repeatAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func didTapShareButton(_ sender: UIButton) {
        if let image = self.imageView.image {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
