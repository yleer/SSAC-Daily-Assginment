//
//  InfoViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher



struct Cast{
    
    var cast_id: Int
    var profile_path: String
    var character: String
    var name: String
    
}

struct Crew{
    var job: String
    var known_for_department: String
    var profile_path: String
}


class InfoViewController: UIViewController {
    
    var movieId : Int!
    var howToShowOverView = false
    var casts: [Cast] = []
    let posterBaseUrl = "https://image.tmdb.org/t/p/w500/"
    var crews: [Crew] = []

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PeopleTableViewCell", bundle: nil)
        infoTableView.register(nib, forCellReuseIdentifier: "PeopleTableViewCell")
        infoTableView.delegate = self
        infoTableView.dataSource = self
        gettingMovieData()
        gettingStaffData()
        
        
    }
    var overview = ""
    func gettingMovieData(){
        let url = "https://api.themoviedb.org/3/movie/\(movieId!)?api_key=6e61b7685e790bc1f3aaed7f5dcdb479&language=en-US"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.overview = json["overview"].stringValue
                let posterUrlString = json["backdrop_path"].stringValue
                let posterUrl = URL(string: self.posterBaseUrl + posterUrlString)
                self.headerImageView.kf.setImage(with: posterUrl)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func gettingStaffData(){
        let url = "https://api.themoviedb.org/3/movie/\(movieId!)/credits?api_key=6e61b7685e790bc1f3aaed7f5dcdb479&language=en-US"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for cast in json["cast"].arrayValue{
                    let tmp = Cast(cast_id: cast["cast_id"].intValue, profile_path: cast["profile_path"].stringValue, character: cast["character"].stringValue, name: cast["name"].stringValue)
                    
                    self.casts.append(tmp)
                }
                for crew in json["crew"].arrayValue{
                    let tmp = Crew(job: crew["job"].stringValue, known_for_department: crew["known_for_department"].stringValue, profile_path: crew["profile_path"].stringValue)
                    
                    self.crews.append(tmp)
                }
                self.infoTableView.reloadData()

                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}


extension InfoViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return casts.count
        }else if section == 2{
            return crews.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    @objc func changeOverviewShowingtype(){
        howToShowOverView = !howToShowOverView
        infoTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Overview") as? OverviewTableViewCell else{
                return UITableViewCell()
            }
            cell.overviewLabel.text = overview
            if howToShowOverView{
                cell.overviewLabel.numberOfLines = 0
            }else{
                cell.overviewLabel.numberOfLines = 2
            }
            cell.seeMoreButton.addTarget(self, action: #selector(changeOverviewShowingtype), for: .touchUpInside)
            return cell
        }else if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell") as? PeopleTableViewCell else{ return UITableViewCell() }

            let url = URL(string: posterBaseUrl + casts[indexPath.row].profile_path)
            cell.poster.kf.setImage(with: url)
            cell.poster.sizeToFit()
            cell.topName.text = casts[indexPath.row].name
            cell.bottomName.text = casts[indexPath.row].character
            
            return cell
        }
        else if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell") as? PeopleTableViewCell else{ return UITableViewCell() }

            let url = URL(string: posterBaseUrl + crews[indexPath.row].profile_path)
            cell.poster.kf.setImage(with: url)
            cell.topName.text = crews[indexPath.row].known_for_department
            cell.bottomName.text = crews[indexPath.row].job
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if howToShowOverView{
                return 200
            }else{
                return 110
            }
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
//    tableviewsection
}
