//
//  SearchViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/15.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let data = ["a","b","c","d","e"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.d
        return UITableViewCell()
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchedTableView.dataSource = self
        searchedTableView.delegate = self
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
