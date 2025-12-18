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
    
    private static let dateFormatter: DateFormatter = {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageCellView.updateAnimatedGradientFrame()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCellView.kf.cancelDownloadTask()
        imageCellView.addAnimatedGradient()
        hideData(true)
    }
    
    //MARK: - Public methods
    func configure(with photo: Photo) {
        updatePhoto(photo: photo)
        if let date = photo.createdAt {
            dateLabel.text = ImagesListCell.dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
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
        hideData(true)
    }
    
    private func hideData(_ hidden: Bool) {
        likeButton.isHidden = hidden
        dateLabel.isHidden = hidden
    }
    
    private func setupImageCellView() {
        imageCellView.translatesAutoresizingMaskIntoConstraints = false
        imageCellView.contentMode = .scaleAspectFit
        imageCellView.layer.cornerRadius = 16
        imageCellView.clipsToBounds = true
        imageCellView.layer.masksToBounds = true
        imageCellView.image = UIImage(resource: .placeholder)
        imageCellView.addAnimatedGradient()
        contentView.addSubview(imageCellView)
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(resource: .active), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.setTitle("", for: .normal)
        contentView.addSubview(likeButton)
    }
    
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .ypWhite
        dateLabel.font = Fonts.sfProTextRegular13
        contentView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
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
        let url = photo.thumbImageURL
        
        let processor = DownsamplingImageProcessor(size: imageCellView.bounds.size)
        imageCellView.kf.indicatorType = .activity
        imageCellView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ){ [weak self] result in
            self?.imageCellView.removeAnimatedGradient()
            
            if case .success = result {
                self?.hideData(false)
            }
        }
    }
    
    @objc private func likeButtonTapped() {
        delegate?.imagesListCellDidTapButton(self)
    }
}
