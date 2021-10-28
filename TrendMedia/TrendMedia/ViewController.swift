//
//  ViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct TmbData{
    var title: String
    var release_date: String
    var poster_path: String
    var id: Int
    var genre_ids: [Int]
}

class ViewController: UIViewController{
   
    let movies = tvShow
    
    @IBOutlet weak var movieTableView: UITableView!
    let posterBaseUrl = "https://image.tmdb.org/t/p/w500/"
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.prefetchDataSource = self
        
        TmbNetworkManager.shared.fetchData(currentPage: currentPage) { statusCode, json in
            let data = json["results"].arrayValue
            for item in data{
                let title = item["title"].stringValue
                let release = item["release_date"].stringValue
                let poster = item["poster_path"].stringValue
                let id = item["id"].intValue
//                let geners = item["genre_ids"].arrayValue as? [Int]
                let geners = [1]
                
                let tmp = TmbData(title: title, release_date: release, poster_path: poster, id: id, genre_ids: geners)
                self.movieData.append(tmp)
            }
            self.movieTableView.reloadData()
        }

    }

    
    @IBAction func infoButtonClicked(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    @IBAction func presentBookVCbutton(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        vc.data = movies
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func segueToWeb(_ sender : UIButton){
        let id = movieData[sender.tag].id
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MovieWebViewControlle") as! MovieWebViewControlle
        vc.id = id
        present(vc, animated: true, completion: nil)
    }
    
    var currentPage = 1
    var movieData : [TmbData] = []
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
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
                        let id = item["id"].intValue
        //                let geners = item["genre_ids"].arrayValue as? [Int]
                        let geners = [1]
                        
                        let tmp = TmbData(title: title, release_date: release, poster_path: poster, id: id, genre_ids: geners)
                        self.movieData.append(tmp)
                    }
                    self.movieTableView.reloadData()
                }
                print("fehcing", indexPaths)
            }
        }
    }
    
    
    // 사용자가 스크롤 빨리 해서 데이터 필요 없으면 다운 취소
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("취소\(indexPaths)")
    }
    
    // MARK: table view part.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        vc.movieId = movieData[indexPath.row].id
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        
        let row = movieData[indexPath.row]
        
        cell.containerView.layer.borderColor = UIColor.gray.cgColor
        cell.containerView.layer.borderWidth = 1
//        cell.genereLabel.text = "#" + row.genre
        cell.englishTitleLabel.text = row.title
        cell.koreanTitleLabel.text = row.title
        cell.dateLabel.text = row.release_date
        
        let url = URL(string: posterBaseUrl + row.poster_path)
        cell.posterImage.kf.setImage(with: url)
        cell.posterImage.image = UIImage(named: row.title)
        cell.toMovieWeb.tag = indexPath.row
        cell.toMovieWeb.addTarget(self, action: #selector(segueToWeb), for: .touchUpInside)
        
        cell.posterImage.layer.cornerRadius = 10
        cell.containerView.layer.cornerRadius = 10
        cell.posterImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
}
