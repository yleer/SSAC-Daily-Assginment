//
//  MainTableViewController.swift
//  ShoppingChekcListAssignment
//
//  Created by Yundong Lee on 2021/10/13.
//

import UIKit


protocol YourCellDelegate  {
    func didPressButton(_ tag: Int)
}


class MainTableViewController: UITableViewController, YourCellDelegate {
    func didPressButton(_ tag: Int) {
        
//        print(shoppingListArray)
        // check button pressed
        if tag % 2 == 0 {
            let row = tag / 2
//            print(row)
            shoppingListArray[row].check = !shoppingListArray[row].check

        }else{
            // like button pressed.
            let row = (tag - 1) / 2
//            print(row)
            shoppingListArray[row].bookMark = !shoppingListArray[row].bookMark
        }

    }
    
    var selectedCheck : [Int] = []
    var selectedBooked : [Int] = []
    
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
        print(shoppingListArray)
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
        if shoppingListArray[indexPath.row].bookMark{
            selectedBooked.append(indexPath.row)
            cell.starButton.imageView?.image = UIImage(systemName: "star.fill")
        }else{
            if let a = selectedBooked.firstIndex(of: indexPath.row){
                selectedBooked.remove(at: a)
            }
            cell.starButton.imageView?.image = UIImage(systemName: "star")
        }

        if shoppingListArray[indexPath.row].check{
            selectedCheck.append(indexPath.row)
            cell.checkBoxButton.imageView?.image = UIImage(systemName: "checkmark.square.fill")
        }else{
            if let a = selectedCheck.firstIndex(of: indexPath.row){
                selectedCheck.remove(at: a)
            }
            cell.checkBoxButton.imageView?.image = UIImage(systemName: "checkmark.square")
        }
    
        
        cell.containerView.layer.cornerRadius = 10
        cell.shoppingContentList.text = shoppingListArray[indexPath.row].content
        
        cell.cellDelegate = self
        cell.checkBoxButton.tag = indexPath.row
        cell.starButton.tag = indexPath.row
        
        
        

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

}
