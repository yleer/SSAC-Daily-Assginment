//
//  InfoContentTableViewCell.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/20.
//

import UIKit

class InfoContentTableViewCell: UITableViewCell {

    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var movieContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
