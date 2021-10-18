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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "base") else{
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "asdf"
        return cell
    }
}
