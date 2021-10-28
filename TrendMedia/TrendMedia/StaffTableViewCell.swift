//
//  StaffTableViewCell.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/28.
//

import UIKit

class StaffTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomName: UILabel!
    @IBOutlet weak var topName: UILabel!
    @IBOutlet weak var poster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
