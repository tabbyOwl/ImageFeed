//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/1.
//

import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
