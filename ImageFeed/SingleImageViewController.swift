//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/1.
//

import UIKit

class SingleImageViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        backButton.setTitle("", for: .normal)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
