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
    
    var cellDelegate: YourCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }
    
//    @IBAction func likeButtonClicked(_ sender: Any) {
////        if like{
////            like = false
////        }else{
////            like = true
////        }
////        print(like)
//        cellDelegate?.didPressButton(sender.tag)
//    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
//        if check{
//            check = false
//        }else{
//            check = true
//        }
//        print(check)
    }
    

}
