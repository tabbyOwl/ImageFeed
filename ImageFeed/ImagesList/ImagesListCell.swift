//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/11/28.
//
import UIKit

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func configure(with image: String) {
        imageCellView.image = UIImage(named: image)
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
    
    @objc private func likeButtonTapped() {
        delegate?.imagesListCellDidTapButton(self)
    }
}
