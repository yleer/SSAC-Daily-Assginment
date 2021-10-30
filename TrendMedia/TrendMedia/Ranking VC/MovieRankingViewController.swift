//
//  MovieRankingViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON


class MovieRankingViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var rankingTableView: UITableView!
    
    
    var movies: [MovieRankData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        searchBar.delegate = self
        
        
        rankingTableView.backgroundView?.backgroundColor = .clear
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=deb3caf441295e781d5f5ae4c155a5aa&targetDt=20211025"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue{
                    let rank = movie["rank"].stringValue
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let data = MovieRankData(rank: rank, movieNm: movieNm, openDt: openDt)
                    self.movies.append(data)
                }
                
                self.rankingTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }

    }
    

    @IBAction func searchButtonClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
}


extension MovieRankingViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("ASDf")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
}

extension MovieRankingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as? RankingTableViewCell{
            cell.backgroundColor = .clear
            
            cell.titleLabel.text = movies[indexPath.row].movieNm
            cell.rankingLabel.backgroundColor = .white
            cell.rankingLabel.text = movies[indexPath.row].rank
            cell.dateLabel.text = movies[indexPath.row].openDt
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
}
