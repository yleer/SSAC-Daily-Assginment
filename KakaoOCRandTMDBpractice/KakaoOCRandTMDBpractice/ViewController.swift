//
//  ViewController.swift
//  KakaoOCRandTMDBpractice
//
//  Created by Yundong Lee on 2021/10/27.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputImage: UIImageView!
    
    @IBOutlet weak var resultTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    var resultString = ""
    @IBAction func changeButtonClicked(_ sender: UIButton) {
        OCRManager.shared.OcrNetwork(image: inputImage.image!) { statusCode, json in
            for result in json["result"].arrayValue{
//                let a =
                self.resultString.append(result["recognition_words"].arrayValue[0].stringValue + " ")
            }
            
            self.resultTextView.text = self.resultString
        }
    }
}

