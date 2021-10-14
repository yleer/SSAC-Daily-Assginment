//
//  ListTableViewCell.swift
//  ShoppingChekcListAssignment
//
//  Created by Yundong Lee on 2021/10/13.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var shoppingContentList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    @IBAction func likeButtonClicked(_ sender: Any) {
//        if like{
//            like = false
//        }else{
//            like = true
//        }
//        print(like)
    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
//        if check{
//            check = false
//        }else{
//            check = true
//        }
//        print(check)
    }
    

}
