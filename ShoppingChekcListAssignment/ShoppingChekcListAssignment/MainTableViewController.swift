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
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var shoppingListArray : [CheckList] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    
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
                let tmp = CheckList(content:shopItem)
                shoppingListArray.insert(tmp, at: 0)
                
                
                var data : [[String : Any]] = []
                for list in shoppingListArray{
                    let li : [String : Any] = [
                        "check" : list.check,
                        "content" : list.content,
                        "bookMark" : list.bookMark
                    ]
                    data.insert(li, at: 0)
                }
                
                UserDefaults.standard.set(data, forKey: "shopping lists")
            }
        }
    }
    
    func loadData(){
        let object  = UserDefaults.standard.object(forKey: "shopping lists")
        guard let shoppingListObject = object as? [[String: Any]] else{
            return
        }
        
        for item in shoppingListObject{
            if let check = item["check"] as? Bool, let content = item["content"] as? String, let bookMark = item["bookMark"] as? Bool{
                let tmp = CheckList(check: check, content: content, bookMark: bookMark)
                shoppingListArray.append(tmp)
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
        cell.containerView.layer.cornerRadius = 10
        cell.shoppingContentList.text = shoppingListArray[indexPath.row].content
        
        
        cell.checkBoxButton.tag = indexPath.row * 2
        cell.starButton.tag = indexPath.row * 2 + 1
        
//        cell.checkBoxButton.addTarget(self, action: #selector(whichButtonPressed(sender:)), for: .touchUpInside)
        cell.checkBoxButton.addTarget(self, action: #selector(whichButtonPressed(sender:)), for: .touchUpInside)
        
        
        cell.starButton.addTarget(self, action: #selector(whichButtonPressed(sender:)), for: .touchUpInside)
        
        
        if shoppingListArray[indexPath.row].bookMark{
            
            cell.starButton.imageView?.image = UIImage(systemName: "star.fill")
        }else{
            cell.starButton.imageView?.image = UIImage(systemName: "star")
        }
        
        if shoppingListArray[indexPath.row].check{
            cell.checkBoxButton.imageView?.image = UIImage(systemName: "checkmark.square.fill")
        }else{
            cell.checkBoxButton.imageView?.image = UIImage(systemName: "checkmark.square")
        }
        
        return cell
    }
    
    @objc func whichButtonPressed(sender: UIButton) {
        let buttonNumber = sender.tag
        
        if buttonNumber % 2 == 0{
            let row = buttonNumber / 2
            shoppingListArray[row].check = !shoppingListArray[row].check
            tableView.reloadData()
        }else{
            let row = (buttonNumber - 1) / 2
            shoppingListArray[row].bookMark = !shoppingListArray[row].bookMark
            tableView.reloadData()
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

}
