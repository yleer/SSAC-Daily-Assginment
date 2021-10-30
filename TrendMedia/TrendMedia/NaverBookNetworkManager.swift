//
//  NaverBookNetworkManager.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/30.
//

import Foundation
import Alamofire
import SwiftyJSON

class NaverBookNetworkManger{
    
    static let shared = NaverBookNetworkManger()
    
    func getBooks(searchString: String, startPage: Int, result: @escaping (Int, JSON) -> ()){
        let url = "https://openapi.naver.com/v1/search/movie.json?query=\(searchString)&display=10&start=\(startPage)"
        AF.request(url, method: .get,headers: Constans.naverHeader).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let statusCode = response.response?.statusCode else{return}
                result(statusCode, json)
            case .failure(let error):
                print(error)
            }
        }
    }
}
