//
//  MovieWebViewControlle.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/18.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class MovieWebViewControlle: UIViewController {
    
    @IBOutlet weak var web: WKWebView!
    var id : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://api.themoviedb.org/3/movie/\(id!)/videos?api_key=6e61b7685e790bc1f3aaed7f5dcdb479&language=en-US"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                let key = json["results"].arrayValue[0]["key"].stringValue
                
                
                let urlString = "https://www.youtube.com/watch?v=" + key
                
                let url = URL(string: urlString)!
                let request = URLRequest(url: url)
                self.web.load(request)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
