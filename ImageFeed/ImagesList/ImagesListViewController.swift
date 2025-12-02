//
//  ViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/11/27.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - @IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private properties
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSourceAndDelegate()
        setupTable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            _ = viewController.view
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private methods
    private func setupDataSourceAndDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupTable() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func addGradientToLabel(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.5).cgColor,
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.7]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - configCell
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: String(indexPath.row)) else {
            return
        }
        cell.imageCellView.image = image
        let date = dateFormatter.string(from: Date())
        cell.dateLabel.text = date
        addGradientToLabel(cell.gradientView)
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(resource: .active) : UIImage(resource: .noActive)
        cell.likeButton.setTitle("", for: .normal)
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
        
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
