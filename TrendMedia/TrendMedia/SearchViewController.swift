//
//  SearchViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as? InfoTableViewCell{
            cell.movieTitle.text = movieData[indexPath.row].title
            cell.movieRating.text = movieData[indexPath.row].userRatingData
            cell.movieSubTitle.text = movieData[indexPath.row].subTitle
            let url = URL(string: movieData[indexPath.row].imageData)
            cell.infoPosterImage.kf.setImage(with: url)

            return cell
        }
        return UITableViewCell()
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchedTableView.dataSource = self
        searchedTableView.delegate = self
        
        fetchData()
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // 네이버 영화 네트워크 통신
    
    var movieData: [MovieModel] = []
    func fetchData(){
        
        if let query = "스파이더맨".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            let url = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=10&start=1&genre=1"
            let header: HTTPHeaders = [
                "X-Naver-Client-Id" : "sbF_TwlMoLeQ5c6xgcEe",
                "X-Naver-Client-Secret" : "hIlG3W6Ymj"
                
            ]
            AF.request(url, method: .get,headers: header).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    for item in json["items"].arrayValue{
                        let title = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                        let image = item["image"].stringValue
                        let link = item["link"].stringValue
                        let userRating = item["userRating"].stringValue
                        let sub = item["subtitle"].stringValue

                        let data = MovieModel(title: title, imageData: image, linkData: link, userRatingData: userRating, subTitle: sub)
                        
                        self.movieData.append(data)
                    }
                    self.searchedTableView.reloadData()
                    print(self.movieData)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
}
