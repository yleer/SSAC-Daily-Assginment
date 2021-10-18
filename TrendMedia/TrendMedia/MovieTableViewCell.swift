//
//  MovieTableViewCell.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
   
    @IBOutlet weak var toMovieWeb: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var genereLabel: UILabel!
    @IBOutlet weak var englishTitleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var koreanTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var similarContentButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
