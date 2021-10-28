//
//  CastTableViewCell.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/28.
//

import UIKit

class CastTableViewCell: UITableViewCell {

    @IBOutlet weak var orginalName: UILabel!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var castImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
