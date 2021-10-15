//
//  ViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    

    let movies = tvShow
    
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }

    
    
    @IBAction func infoButtonClicked(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: table view part.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        
        let row = movies[indexPath.row]
            
        cell.genereLabel.text = "#" + row.genre
        cell.englishTitleLabel.text = row.title
        cell.koreanTitleLabel.text = row.title
        cell.dateLabel.text = row.releaseDate
        cell.posterImage.image = UIImage(named: row.title)
        
        cell.posterImage.layer.cornerRadius = 10
        cell.containerView.layer.cornerRadius = 10
        cell.posterImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
}

