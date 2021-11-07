//
//  MovieRankingViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift


class MovieRankingViewController: UIViewController {
    let localRealm = try! Realm()
    var movieTitles: List<String> = List()
    var movieRankings: List<String> = List()
    var movieRealeaseDate: List<String> = List()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var rankingTableView: UITableView!
    var searchDate: String = "20200427"{
        didSet{
                if let specificPerson = localRealm.object(ofType: LocalOnlyQsTask.self, forPrimaryKey: searchDate){
                    self.movies = []
                    self.movieTitles.removeAll()
                    self.movieRankings.removeAll()
                    self.movieRealeaseDate.removeAll()

                    for index in specificPerson.title.indices{
                        let tmp = MovieRankData(rank: specificPerson.ranking[index], movieNm: specificPerson.title[index], openDt: specificPerson.releaseDate[index])
                        
                        movies.append(tmp)
                    }
                    self.rankingTableView.reloadData()
                    
                }else{
                    self.movies = []
                    self.movieTitles.removeAll()
                    self.movieRankings.removeAll()
                    self.movieRealeaseDate.removeAll()
                    self.network()
                    }
        }
    }
    var movies: [MovieRankData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        searchBar.delegate = self
        print(localRealm.configuration.fileURL)
    
        if let specificPerson = localRealm.object(ofType: LocalOnlyQsTask.self, forPrimaryKey: searchDate){
            self.movies = []
            self.movieTitles.removeAll()
            self.movieRankings.removeAll()
            self.movieRealeaseDate.removeAll()

            for index in specificPerson.title.indices{
                let tmp = MovieRankData(rank: specificPerson.ranking[index], movieNm: specificPerson.title[index], openDt: specificPerson.releaseDate[index])
                
                movies.append(tmp)
            }
            self.rankingTableView.reloadData()
            
        }else{
            network()
        }
        
    }
    
    func network() {
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=deb3caf441295e781d5f5ae4c155a5aa&targetDt=\(searchDate)"
        
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
                    self.movieTitles.append(movieNm)
                    self.movieRankings.append(rank)
                    self.movieRealeaseDate.append(openDt)
                    self.movies.append(data)
                }
                
                let task = LocalOnlyQsTask(rankingDate: self.searchDate, title: self.movieTitles, ranking: self.movieRankings, releaseDate: self.movieRealeaseDate)
                try! self.localRealm.write {
                    
                    self.localRealm.add(task)
                }
                
                self.rankingTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension MovieRankingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedword = searchBar.text{
            searchDate = searchedword
        }
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
