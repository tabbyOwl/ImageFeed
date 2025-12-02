//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/1.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var shareButton: UIButton!
    
    // MARK: - Public properties
     var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
                imageView.frame.size = image.size
                configFor(imageSize: image.size)
            }
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerImage()
    }
    
    // MARK: - Private methods
    private func setupButton() {
        backButton.setTitle("", for: .normal)
    }
    
    private func setupImage() {
        guard let image = image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        setMinimumAndMaximumZoomScale()
    }
    
    func configFor(imageSize: CGSize) {
        self.scrollView.contentSize = imageSize
        
        setMinimumAndMaximumZoomScale()
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    private func setMinimumAndMaximumZoomScale() {
        let boundsSize = self.view.bounds.size
        let imageSize = self.imageView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale > 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        
        if minScale > 0.5 {
            maxScale = max(1, minScale)
        }
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
    }
    
    private func centerImage() {
        let boundsSize = self.view.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
        present(activityViewController, animated: true, completion: nil)
    }

    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
     
}
