//
//  StaffDetailViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/31.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


// MARK: need to change default cell to custom cell later.

class StaffDetailViewController: UIViewController {
    
   
    var id: Int?

    var movieData: [TmbData] = []
    @IBOutlet weak var workedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        workedTableView.delegate = self
        workedTableView.dataSource = self
        
        TmbNetworkManager.shared.getStaffInfoById(id: id!) { statusCode, json in
            for movie in json["crew"].arrayValue{
                let genersJson = movie["genre_ids"].arrayValue
                var genres: [Int] = []
                for gener in genersJson {
                    genres.append(gener.intValue)
                }
                let tmp = TmbData(title: movie["title"].stringValue, release_date: movie["release_date"].stringValue, poster_path: movie["poster_path"].stringValue, id: movie["id"].intValue, genre_ids: genres)
                
                self.movieData.append(tmp)
            }
            
            DispatchQueue.main.async {
                self.workedTableView.reloadData()
                if self.movieData.count == 0{
                    let alertVc = UIAlertController(title: "해당 인물의 작품이 가져올 수 없습니다.", message: "", preferredStyle: .alert)
                    
                    let oKbutton = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertVc.addAction(oKbutton)
                    
                    
                    self.present(alertVc, animated: true, completion: nil)
                }
            }
        } errorResult: {
            let alertVc = UIAlertController(title: "해당 인물의 작품이 가져올 수 없습니다.", message: "", preferredStyle: .alert)
            
            let oKbutton = UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            
            alertVc.addAction(oKbutton)
            
        
            self.present(alertVc, animated: true, completion: nil)
        }

    }
}





extension StaffDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Base", for: indexPath) as! UITableViewCell
        
        
        let urlStirng = Constans.posterBaseUrl + movieData[indexPath.row].poster_path
        
        guard let imageUrl = URL(string: urlStirng) else{return cell}
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "no image"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        cell.textLabel?.text = movieData[indexPath.row].title
        cell.detailTextLabel?.text = movieData[indexPath.row].release_date
        
        
      
        
        return cell
    }
    
    
}
