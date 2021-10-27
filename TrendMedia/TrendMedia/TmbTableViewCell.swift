//
//  TmbTableViewCell.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/27.
//

import UIKit

class TmbTableViewCell: UITableViewCell {

    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
