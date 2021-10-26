//
//  ViewController.swift
//  LotteryAssignment
//
//  Created by Yundong Lee on 2021/10/25.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    var latest = 986
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var balls: [UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.dataSource = self
        pickerView.delegate = self
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=986"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.name.text = json["drwNo"].stringValue
                
                self.balls[0].text = json["drwtNo1"].stringValue
                self.balls[1].text = json["drwtNo2"].stringValue
                self.balls[2].text = json["drwtNo3"].stringValue
                self.balls[3].text = json["drwtNo4"].stringValue
                self.balls[4].text = json["drwtNo5"].stringValue
                self.balls[5].text = json["drwtNo6"].stringValue
                self.balls[6].text = json["bnusNo"].stringValue
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }

}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        latest
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(row)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.name.text = json["drwNo"].stringValue
                
                self.balls[0].text = json["drwtNo1"].stringValue
                self.balls[1].text = json["drwtNo2"].stringValue
                self.balls[2].text = json["drwtNo3"].stringValue
                self.balls[3].text = json["drwtNo4"].stringValue
                self.balls[4].text = json["drwtNo5"].stringValue
                self.balls[5].text = json["drwtNo6"].stringValue
                self.balls[6].text = json["bnusNo"].stringValue
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
