//
//  TmbViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/27.
//

import UIKit

class TmbViewController: UIViewController {

    @IBOutlet weak var contentTableView: UITableView!
    var currentPage = 1
    var movieData : [TmbData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.prefetchDataSource = self
        TmbNetworkManager.shared.fetchData(currentPage: currentPage) { statusCode, json in
            let data = json["results"].arrayValue
            for item in data{
                let title = item["title"].stringValue
                let release = item["release_date"].stringValue
                let poster = item["poster_path"].stringValue
//                let tmp = TmbData(title: title, release_date: release, poster_path: poster)
//                self.movieData.append(tmp)
            }
            self.contentTableView.reloadData()
        }
    }
}

extension TmbViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieData.count - 2 == indexPath.row{
                currentPage += 1
                TmbNetworkManager.shared.fetchData(currentPage: currentPage) { statusCode, json in
                    let data = json["results"].arrayValue
                    for item in data{
                        let title = item["title"].stringValue
                        let release = item["release_date"].stringValue
                        let poster = item["poster_path"].stringValue
//                        let tmp = TmbData(title: title, release_date: release, poster_path: poster)
//                        self.movieData.append(tmp)
                    }
                    self.contentTableView.reloadData()
                }
                print("fehcing", indexPaths)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TmbTableViewCell", for: indexPath) as? TmbTableViewCell else {return UITableViewCell()}
        
        cell.movieTitle.text = movieData[indexPath.row].title
        cell.movieReleaseDate.text = movieData[indexPath.row].release_date
        // 나중에 영화 포스터 처리해야됨.
        return cell
    }
    
    
}
