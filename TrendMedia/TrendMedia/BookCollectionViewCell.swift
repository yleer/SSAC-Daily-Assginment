//
//  BookCollectionViewCell.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/19.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    static let identifier = "BookCollectionViewCell"
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var moviePoster: UIImageView!
}
