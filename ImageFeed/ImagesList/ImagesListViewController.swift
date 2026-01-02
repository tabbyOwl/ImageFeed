//
//  ViewController.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/11/27.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func insertRows(oldCount: Int, newCount: Int)
    func reloadRows(indexPaths: [IndexPath])
    func hideLoadingHUD()
    func showLoadingHUD()
    func reloadData()
    func showError()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    // MARK: - Private properties
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func reloadRows(indexPaths: [IndexPath]) {
        self.tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func insertRows(oldCount: Int, newCount: Int) {
        self.tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func hideLoadingHUD() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showLoadingHUD() {
        UIBlockingProgressHUD.show()
    }
    
    // MARK: - Private methods
    private func setupDataSourceAndDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        setupTable()
        setupConstraints()
        setupDataSourceAndDelegate()
    }
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.backgroundColor = .ypBlack
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {return UITableViewCell()}
        if let photo = self.presenter?.getPhoto(at: indexPath.row) {
            cell.delegate = self
            cell.configure(with: photo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.photosCount {
            self.presenter?.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageVC = SingleImageViewController()
        if let photo = presenter?.getPhoto(at: indexPath.row) {
            let url = photo.fullImageURL
            singleImageVC.url = url
            navigationController?.pushViewController(singleImageVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhoto(at: indexPath.row) else { return 0}
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapButton(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let photo = presenter?.getPhoto(at: indexPath.row) {
            presenter?.handleLikeButtonTap(photo: photo, indexPath: indexPath)
        }
    }
    
    func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробуйте еще раз",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ок", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
