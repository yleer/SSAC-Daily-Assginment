//
//  ViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit
import Network

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
    
    @IBOutlet var buttons: [UIButton]!
    var movieData : [TmbData] = []
    var currentPage = 1
    @IBOutlet weak var movieTableView: UITableView!
    var generDic: [Int: String] = [:]
    
    func fetchData(){
        TmbNetworkManager.shared.fetchTrendData(currentPage: currentPage) { statusCode, json in
            let data = json["results"].arrayValue
            for item in data{
                let title = item["title"].stringValue
                let release = item["release_date"].stringValue
                let poster = item["poster_path"].stringValue
                let id = item["id"].intValue
                let genersJson = item["genre_ids"].arrayValue
                var genres: [Int] = []
                for gener in genersJson {
                    genres.append(gener.intValue)
                }
                
                let tmp = TmbData(title: title, release_date: release, poster_path: poster, id: id, genre_ids: genres)
                self.movieData.append(tmp)
            }
            
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
    }
    
    let networkMonitor = NWPathMonitor()
    
    func networkCheck(){
        networkMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                print("good network")
                if path.usesInterfaceType(.cellular){
                    print("cellular network")
                }else if path.usesInterfaceType(.wifi){
                    print("wifi network")
                }
                else{
                print("other network")
                }
            }else{
                let alertVC = UIAlertController(title: "???????????? ?????? ??????", message: "???????????? ????????? ????????? ?????????.", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "??????", style: .default)
                alertVC.addAction(okButton)
                print("bad network")
                
                self.present(alertVC, animated: true)
            }
            
        }
        networkMonitor.start(queue: DispatchQueue.global())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.setTitle("", for: .normal)
        }
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.prefetchDataSource = self
        fetchData()
        networkCheck()
        
        TmbNetworkManager.shared.generIDs { statusCode, json in
            for item in json["genres"].arrayValue{
                self.generDic[item["id"].intValue] = item["name"].stringValue
            }
        }
        
    }

    
    @objc func segueToWeb(_ sender : UIButton){
        let id = movieData[sender.tag].id
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MovieWebViewControlle") as! MovieWebViewControlle
        vc.id = id
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieData.count - 2 == indexPath.row{
                currentPage += 1
                fetchData()
                print("fehcing", indexPaths)
            }
        }
    }


    // ???????????? ????????? ?????? ?????? ????????? ?????? ????????? ?????? ??????
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("??????\(indexPaths)")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identfier, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        
        let row = movieData[indexPath.row]
        
        cell.containerView.layer.borderColor = UIColor.gray.cgColor
        cell.containerView.layer.borderWidth = 1
        
        var genereText = ""
        
        for id in row.genre_ids{
            let tmp = generDic[id] ?? ""
            genereText = genereText + " #" + tmp
        }
        
        cell.genereLabel.text = genereText
        cell.englishTitleLabel.text = row.title
        cell.koreanTitleLabel.text = row.title
        cell.dateLabel.text = row.release_date
        
        let url = URL(string: Constans.posterBaseUrl + row.poster_path)
        cell.posterImage.kf.setImage(with: url)
        cell.toMovieWeb.tag = indexPath.row
        cell.toMovieWeb.addTarget(self, action: #selector(segueToWeb), for: .touchUpInside)
        cell.toMovieWeb.backgroundColor = .clear
        cell.toMovieWeb.layer.cornerRadius = 10
        cell.toMovieWeb.layer.borderWidth = 2
        
        
        cell.posterImage.layer.cornerRadius = 10
        cell.containerView.layer.cornerRadius = 10
        cell.posterImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
}
