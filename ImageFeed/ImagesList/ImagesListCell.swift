//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/11/28.
//
import UIKit

final class ImagesListCell: UITableViewCell {

    @IBOutlet weak var imageCellView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
}
