//
//  MainTableViewController.swift
//  ShoppingChekcListAssignment
//
//  Created by Yundong Lee on 2021/10/13.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    let localRealm = try! Realm()
    var tasks: Results<ShoppingData>!
    
    var selectedCheck : [Int] = []
    var selectedBooked : [Int] = []
    
    //    list cell
    
    @IBOutlet weak var shoppingTextField: UITextField!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        headerContainerView.layer.cornerRadius = 20
        addButton.layer.cornerRadius = 20
        
    }
  
    @IBAction func shoppingListEndEditing(_ sender: UITextField) {
        saveDate()
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        saveDate()
    }
    
    func saveDate(){
        if let shopItem = shoppingTextField.text{
            if shopItem.count != 0{
                let task = ShoppingData(item: shopItem, currentDate: Date())
                try! localRealm.write {
                    localRealm.add(task)
                }
            }
        }
        tableView.reloadData()
    }
    
    func loadData(){
        tasks = localRealm.objects(ShoppingData.self)
        
        tasks = tasks.sorted(byKeyPath: "createdDate", ascending: false)
        
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as? ListTableViewCell else{
            return UITableViewCell()
        }
        
        cell.containerView.layer.cornerRadius = 10
        cell.shoppingContentList.text = tasks[indexPath.row].shoppingItem
        

        cell.checkBoxButton.tag = indexPath.row
        cell.starButton.tag = indexPath.row
        
        
        

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

}
