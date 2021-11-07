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
    var tasks: Results<ShoppingData>!{
        didSet{
            tableView.reloadData()
        }
    }
    
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
    
    @IBAction func searchSetting(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        // Access all dogs in the realm
        let shoppingList = realm.objects(ShoppingData.self)
        
        let alertVc = UIAlertController(title: "정렬방식을 골라주세요.", message: "이름, 만든 날짜, 쇼핑 확인 여부.", preferredStyle: .alert)
        
        let sortByName = UIAlertAction(title: "이름으로 정렬", style: .default) { _ in
            self.tasks = shoppingList.sorted(byKeyPath: "shoppingItem", ascending: false)
            
        }
        let sortByDate = UIAlertAction(title: "날짜로 정렬", style: .default) { _ in
            self.tasks = shoppingList.sorted(byKeyPath: "createdDate", ascending: false)
            
        }
        let sortByDone = UIAlertAction(title: "완료 여부 정렬", style: .default) { _ in
            self.tasks = shoppingList.sorted(byKeyPath: "done", ascending: false)
            
        }
        

        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        alertVc.addAction(sortByName)
        alertVc.addAction(sortByDate)
        alertVc.addAction(sortByDone)
        alertVc.addAction(cancelButton)
        
        present(alertVc, animated: true, completion: nil)
        
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
    
    @objc func chekcButtonClicked(_ sender: UIButton){
        let taskToUpdate = tasks[sender.tag]
        print(taskToUpdate.done)
        try! localRealm.write {
            taskToUpdate.done = !taskToUpdate.done
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
    }
    
    @objc func specialButtonClicked(_ sender: UIButton){
        // 아래 라움에서 코드 가져와서 고쳐 update하는거.
        let taskToUpdate = tasks[sender.tag]
        print(taskToUpdate.special)
        try! localRealm.write {
            taskToUpdate.special = !taskToUpdate.special
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
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
        
        cell.starButton.addTarget(self, action: #selector(specialButtonClicked), for: .touchUpInside)
        cell.starButton.setTitle("", for: .normal)
        cell.checkBoxButton.addTarget(self, action: #selector(chekcButtonClicked), for: .touchUpInside)
        cell.checkBoxButton.setTitle("", for: .normal)
        
        
        
        cell.checkBoxButton.tag = indexPath.row
        cell.starButton.tag = indexPath.row
        
        print(tasks[indexPath.row].special,tasks[indexPath.row].done)
        if tasks[indexPath.row].special{
            cell.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            cell.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        if tasks[indexPath.row].done{
            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        
        
        

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! localRealm.write{
            // Realm에서만 삭제한거임. -> 이미지 url에 찾아가 이미지도 직접 삭제해야됨.
            localRealm.delete(tasks[indexPath.row])
            tableView.reloadData()
        }
    }
}
