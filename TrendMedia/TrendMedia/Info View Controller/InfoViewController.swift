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
    var credut_id: String
    var id: Int
}


class InfoViewController: UIViewController {
    
    var movieId : Int!
    var howToShowOverView = false
    var casts: [Cast] = []
    var crews: [Crew] = []
    var overview = ""
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: PeopleTableViewCell.identifier, bundle: nil)
        infoTableView.register(nib, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        infoTableView.rowHeight = UITableView.automaticDimension
        
        if let id = movieId{
            fetchData(id: id)
        }

    }
    func fetchData(id: Int){
        TmbNetworkManager.shared.fetchMovieByID(movieId: id) { statusCode, json in
            self.overview = json["overview"].stringValue
            let posterUrlString = json["backdrop_path"].stringValue
            let posterUrl = URL(string: Constans.posterBaseUrl + posterUrlString)
            self.headerImageView.kf.setImage(with: posterUrl)
        }
        
        TmbNetworkManager.shared.gettingStaffData(movieId: id) { statusCode, json in
            for cast in json["cast"].arrayValue{
                let tmp = Cast(cast_id: cast["cast_id"].intValue, profile_path: cast["profile_path"].stringValue, character: cast["character"].stringValue, name: cast["name"].stringValue)
                self.casts.append(tmp)
            }
            for crew in json["crew"].arrayValue{
                let tmp = Crew(
                    job: crew["job"].stringValue,
                    known_for_department: crew["known_for_department"].stringValue,
                    profile_path: crew["profile_path"].stringValue,
                    credut_id: crew["credit_id"].stringValue,
                    id: crew["id"].intValue
                )
                self.crews.append(tmp)
            }
            DispatchQueue.main.async {
                self.infoTableView.reloadData()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier) as? PeopleTableViewCell else{ return UITableViewCell() }

            let imageUrl = URL(string: Constans.posterBaseUrl + casts[indexPath.row].profile_path)
            
            cell.poster.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "no image"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            cell.topName.text = casts[indexPath.row].name
            cell.bottomName.text = casts[indexPath.row].character
            
            return cell
        }
        else if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier) as? PeopleTableViewCell else{ return UITableViewCell() }

            let imageUrl = URL(string: Constans.posterBaseUrl + crews[indexPath.row].profile_path)
            cell.poster.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "no image"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            cell.topName.text = crews[indexPath.row].known_for_department
            cell.bottomName.text = crews[indexPath.row].job
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Casts"
        }else if section == 2{
            return "Crew"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0{
            return 100
        }else{
            return infoTableView.rowHeight
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "StaffDetailViewController") as! StaffDetailViewController
        if indexPath.section == 1 {
            vc.id = casts[indexPath.row].cast_id
        }else if indexPath.section == 2 {
            vc.id = crews[indexPath.row].id
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
