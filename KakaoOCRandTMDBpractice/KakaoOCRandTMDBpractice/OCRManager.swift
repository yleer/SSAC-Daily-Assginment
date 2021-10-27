//
//  OCRManager.swift
//  KakaoOCRandTMDBpractice
//
//  Created by Yundong Lee on 2021/10/27.
//

import Alamofire
import SwiftyJSON
import UIKit

class OCRManager{
    
    static let shared = OCRManager()
    
    let header: HTTPHeaders =  [
        "Authorization" :"KakaoAK a99b0644d3c5ac2b7f2ecdebbe63ff36",
        "Content-Type" : "multipart/form-data"
    ]

    
    func OcrNetwork(image : UIImage, result: @escaping (Int, JSON) ->()){
        let url = "https://dapi.kakao.com/v2/vision/text/ocr"
        
        guard let data = image.pngData() else {return}
        //        AF.upload(data, to: url, headers: header)
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: "image", mimeType: nil)
        }, to: url , headers : header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let code = response.response?.statusCode
                result(code!, json)
            
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}
