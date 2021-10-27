//
//  TmbNetworkManager.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON

struct TmbData{
    var title: String
    var release_date: String
    var poster_path: String
}

class TmbNetworkManager{
    
    static let shared = TmbNetworkManager()
    
    func fetchData(currentPage: Int, result: @escaping (Int, JSON)-> ()){
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=6e61b7685e790bc1f3aaed7f5dcdb479&page=\(currentPage)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                guard let code = response.response?.statusCode else{ return}
                result(code, json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
