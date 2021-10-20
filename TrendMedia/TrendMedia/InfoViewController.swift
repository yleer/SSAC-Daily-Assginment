//
//  InfoViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit
import Kingfisher

class InfoViewController: UIViewController {
    
    var program : TvShow?
    
    var howToShowOverView = false

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        getHeaderImage()
    }
    
    func getHeaderImage(){
        guard let urlString = program?.backdropImage else{
            return
        }

        headerImageView.image = UIImage(named: "A tale dark grimm")
        headerImageView.contentMode = .scaleAspectFill
        
        let url = URL(string: urlString)
        headerImageView.kf.setImage(with : url)
        
    }

}


extension InfoViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 10
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    @objc func changeOverviewShowingtype(){
        howToShowOverView = !howToShowOverView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoContent") as? InfoContentTableViewCell else{
                return UITableViewCell()
            }
            cell.movieContentLabel.text = program?.overview
            if howToShowOverView{
                cell.movieContentLabel.numberOfLines = 0
            }else{
                cell.movieContentLabel.numberOfLines = 2
            }
            cell.showMoreButton.addTarget(self, action: #selector(changeOverviewShowingtype), for: .touchUpInside)
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "base") else{
                return UITableViewCell()
            }
            
            cell.textLabel?.text = "asdf"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
        }else{
            return 100
        }
    }
    
//    tableviewsection
}
