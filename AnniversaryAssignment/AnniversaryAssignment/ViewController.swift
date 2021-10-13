//
//  ViewController.swift
//  AnniversaryAssignment
//
//  Created by Yundong Lee on 2021/10/07.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var topLeftUpperLabel: UILabel!
    @IBOutlet weak var topLeftCenterLabel: UILabel!
    
    
    @IBOutlet weak var topRightUpperLabel: UILabel!
    @IBOutlet weak var topRightCenterLabel: UILabel!
    
    @IBOutlet weak var bottomLeftUpperLabel: UILabel!
    @IBOutlet weak var bottomLeftCenterLabel: UILabel!
    
    
    @IBOutlet weak var bottomRightLeftUpperLabel: UILabel!
    
    @IBOutlet weak var bottomRightCenterLabel: UILabel!
    
    @IBOutlet weak var topLeftImage: UIImageView!
    @IBOutlet weak var topRightImage: UIImageView!
    @IBOutlet weak var bottomRightImage: UIImageView!
    @IBOutlet weak var bottomLeftImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.systemVersion.hasPrefix("14") || UIDevice.current.systemVersion.hasPrefix("15"){
            datePicker.preferredDatePickerStyle = .inline
        }else{
            datePicker.preferredDatePickerStyle = .wheels
        }
        
       
        topLeftImage.layer.cornerRadius = 25
        topRightImage.layer.cornerRadius = 25
        bottomLeftImage.layer.cornerRadius = 25
        bottomRightImage.layer.cornerRadius = 25
        
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        var currentDate = sender.date
        let hunderedDays = 60 * 60 * 24 * 100
        currentDate.addTimeInterval(TimeInterval(hunderedDays))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        var convertDate = dateFormatter.string(from:currentDate)
        topLeftCenterLabel.text = "\(convertDate)"

        currentDate.addTimeInterval(TimeInterval(hunderedDays))
        convertDate = dateFormatter.string(from:currentDate)
        topRightCenterLabel.text = "\(convertDate)"
        
        
        currentDate.addTimeInterval(TimeInterval(hunderedDays))
        convertDate = dateFormatter.string(from:currentDate)
        bottomLeftCenterLabel.text = "\(convertDate)"
        
        
        currentDate.addTimeInterval(TimeInterval(hunderedDays))
        convertDate = dateFormatter.string(from:currentDate)
        bottomRightCenterLabel.text = "\(convertDate)"

    }


}

