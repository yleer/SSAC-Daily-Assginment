//
//  MainTableViewController.swift
//  ShoppingChekcListAssignment
//
//  Created by Yundong Lee on 2021/10/13.
//

import UIKit

class MainTableViewController: UITableViewController {
    //    list cell
    
    @IBOutlet weak var shoppingTextField: UITextField!
    
    var shoppingListArray : [String] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @IBAction func shoppingListEndEditing(_ sender: UITextField) {
        if let shopItem = shoppingTextField.text{
            if shopItem.count != 0{
                shoppingListArray.insert(shopItem, at: 0)
            }
            
        }
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        if let shopItem = shoppingTextField.text{
            if shopItem.count != 0{
                shoppingListArray.insert(shopItem, at: 0)
            }
            
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "list cell", for: indexPath) as? ListTableViewCell else{
            return UITableViewCell()
        }
        
        cell.shoppingContentList.text = shoppingListArray[indexPath.row]
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

}
