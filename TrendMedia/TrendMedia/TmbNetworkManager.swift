//
//  TmbNetworkManager.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON



class TmbNetworkManager{
    
    static let shared = TmbNetworkManager()
                 
    func fetchTrendData(currentPage: Int, result: @escaping (Int, JSON)-> ()){
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(Constans.TMDBapiKey)&page=\(currentPage)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let code = response.response?.statusCode else{ return}
                result(code, json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchMovieByID(movieId: Int, result : @escaping (Int, JSON) -> ()) {
        let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Constans.TMDBapiKey)&language=en-US"
        
        AF.request(url, method: .get).validate().responseJSON { response in
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
    
    func gettingStaffData(movieId: Int, result: @escaping (Int, JSON) -> ()) {
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(Constans.TMDBapiKey)&language=en-US"
        AF.request(url, method: .get).validate().responseJSON { response in
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
