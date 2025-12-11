//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/11/28.
//
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapButton(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    //MARK: - Private properties
    private let imageCellView = UIImageView()
    private let likeButton = UIButton()
    private let dateLabel = UILabel()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Public methods
    func configure(with photo: Photo) {
        
        updatePhoto(photo: photo)
        dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        setLike(isLiked: photo.isLiked)
    }
    
    func setLike(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(resource: .active) : UIImage(resource: .noActive)
        likeButton.setImage(likeImage, for: .normal)
    }
    
    //MARK: - Private methods
    private func setupUI() {
        backgroundColor = .ypBlack
        setupImageCellView()
        setupLikeButton()
        setupDateLabel()
        setupConstraints()
    }
    
    private func setupImageCellView() {
        imageCellView.translatesAutoresizingMaskIntoConstraints = false
        imageCellView.contentMode = .scaleAspectFit
        imageCellView.layer.cornerRadius = 16
        imageCellView.clipsToBounds = true
        imageCellView.layer.masksToBounds = true
        self.addSubview(imageCellView)
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(resource: .active), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.setTitle("", for: .normal)
        self.addSubview(likeButton)
    }
    
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .ypWhite
        dateLabel.font = Fonts.sfProTextRegular13
        let date = dateFormatter.string(from: Date())
        dateLabel.text = date
        self.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            imageCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            imageCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            imageCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            likeButton.topAnchor.constraint(equalTo: imageCellView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageCellView.trailingAnchor),
            
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            dateLabel.bottomAnchor.constraint(equalTo: imageCellView.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: imageCellView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: imageCellView.trailingAnchor)
        ])
    }
    
    private func updatePhoto(photo: Photo) {
        guard let url = URL(string: photo.thumbImageURL) else {
            imageCellView.image = UIImage(systemName: "xmark.circle")
            return
        }
        
        let processor = DownsamplingImageProcessor(size: imageCellView.bounds.size)
        imageCellView.kf.indicatorType = .activity
        imageCellView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
    
    @objc private func likeButtonTapped() {
        delegate?.imagesListCellDidTapButton(self)
    }
}
