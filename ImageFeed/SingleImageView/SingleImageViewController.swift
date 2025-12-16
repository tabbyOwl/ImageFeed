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
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.bouncesZoom = true
        view.addSubview(scrollView)
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFit
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
    
    private func rescaleAndCenterImage(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
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
    private func loadImage() {
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                imageView.frame.size = imageResult.image.size
                scrollView.contentSize = imageResult.image.size
                rescaleAndCenterImage(image: imageResult.image)
            case .failure:
                print("ERROR")
                //self.showError()
            }
        }
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
