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

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    
    var movieData: [BookData] = []
    var startPage = 1
    var curresntSearchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchedTableView.dataSource = self
        searchedTableView.delegate = self
        searchedTableView.prefetchDataSource = self
        searchBar.delegate = self
    }

    // 네이버 영화 네트워크 통신
    
    func fetchData(query: String){
        
        if let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                
            NaverBookNetworkManger.shared.getBooks(searchString: query, startPage: startPage) { statusCode, json in
                for item in json["items"].arrayValue{
                    let title = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                    let image = item["image"].stringValue
                    let link = item["link"].stringValue
                    let userRating = item["userRating"].stringValue
                    let sub = item["subtitle"].stringValue

                    let data = BookData(title: title, imageData: image, linkData: link, userRatingData: userRating, subTitle: sub)
                    
                    self.movieData.append(data)
                }//
                
                DispatchQueue.main.async {
                    self.searchedTableView.reloadData()
                    self.searchedTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
            }
        }
    }
}
extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            movieData.removeAll()
            curresntSearchString = text
            startPage = 1
            fetchData(query: text)
            
        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        movieData.removeAll()
        searchedTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    //cell for row at 전에 필요한 데이터 미리 다운받는 함수.
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieData.count - 2 == indexPath.row{
                startPage += 10
                fetchData(query: curresntSearchString)
            }
        }
    }
    
    // 사용자가 스크롤 빨리 해서 데이터 필요 없으면 다운 취소
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("취소\(indexPaths)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identfier, for: indexPath) as? InfoTableViewCell{
            cell.movieTitle.text = movieData[indexPath.row].title
            cell.movieRating.text = movieData[indexPath.row].userRatingData
            cell.movieSubTitle.text = movieData[indexPath.row].subTitle
            let url = URL(string: movieData[indexPath.row].imageData)
            cell.infoPosterImage.kf.setImage(with: url)

            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}
