//
//  ToDoTableViewController.swift
//  FinalProjectSwift
//
//  Created by Shaarbaf-Toosi, Saba [ITUIS] on 3/23/18.
//  Copyright © 2018 Iowa State university. All rights reserved.
//

import Masonry
import UIKit
import SnapKit
import RealmSwift

class Item: Object {
    @objc dynamic var name = ""
    @objc dynamic var completed = false
    @objc dynamic var category = ""
    
    override class func primaryKey() -> String? {
        return "name"
    }
}


class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    //properties to hold data
    var categories: [String] {
        get {
            return Array(dict.keys)
        }
    };
    
    let flag = AddCategoryOrItemView()
    let reuseIdentifier = "cell"
    let doneButton = UIButton()
    let tableView = UITableView()
    let addCategoryButtonMasonry = UIButton()
    var keyboardHeight: Double!
    var sectionTitle: String?
    var notice = 0
    var realm: Realm!
    var dict: Dictionary<String, [Item]> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up for realm
        realm = try! Realm()
        
//        try! realm.write {
//            realm.deleteAll()
//        }
        
        let items = realm.objects(Item.self)
        
        dict["To-Do"] = [Item()]
        
        for item in items{
            if(!categories.contains(item.category))
            {
                
                dict[item.category] = []
            }
            dict[item.category]?.append(item)
           
        }
      
        //set up view
        self.view.addSubview(flag)
        flag.isHidden = true
        flag.doneButton.addTarget(self, action: #selector(self.doneAction(sender:)), for: .touchUpInside)
        flag.cancelButton.addTarget(self, action: #selector(self.cancelAction(sender:)), for: .touchUpInside)
        
        flag.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.centerY.equalTo(view)
            make.left.right.equalTo(view)
        }
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        buttonSetUp()
        tableViewSetUp()
    }
    
    @objc func doneAction(sender: UIButton)
    {
        
        //item
        if(notice == 1)
        {
          
            let newItemRealm = Item()
            newItemRealm.name = flag.categoryNameText.text!
            newItemRealm.category = sectionTitle!
            newItemRealm.completed = false
            dict[sectionTitle!]?.append(newItemRealm)
            
            //add to database
            try! self.realm.write({
                self.realm.add(newItemRealm)
                
                let section = categories.index(of: newItemRealm.category)
                self.tableView.insertRows(at: [IndexPath.init(row: (self.dict[newItemRealm.category]?.count)!-1, section: section!)], with: .automatic)
            })
        }
        //category
        else if(notice == 0)
        {
            dict[flag.categoryNameText.text!] = [Item()]
        }
        
        flag.isHidden = true
        view.endEditing(true)
        tableView.reloadData()
        flag.categoryNameText.text = ""
    }
    
    @objc func cancelAction(sender: UIButton)
    {
        view.endEditing(true)
        flag.isHidden = true
    }

    func buttonSetUp()
    {
        view.addSubview(addCategoryButtonMasonry)
        addCategoryButtonMasonry.setTitle("Add Category", for: .normal)
        addCategoryButtonMasonry.backgroundColor = UIColor.blue
        addCategoryButtonMasonry.setTitleColor(UIColor.white, for: .normal)
        addCategoryButtonMasonry.layer.cornerRadius = 10
        
        addCategoryButtonMasonry.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.width.equalTo(125)
            make.height.equalTo(40)
        }
        
        addCategoryButtonMasonry.addTarget(self, action: #selector(showCategorySubview(sender:)), for: .touchUpInside)
    }
    
    
    func tableViewSetUp()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.insertSubview(tableView, at: 0)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(addCategoryButtonMasonry).offset(-50)
        }
        let imageView = UIImageView()
        
        tableView.addSubview(imageView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FirstCell")
    }
    
    //show category subview
    @objc func showCategorySubview(sender: UIButton!)
    {
        flag.categoryNameText.text = ""
        
        if flag.isHidden {
            flag.isHidden = false
        } else {
            flag.isHidden = true
        }
        
        flag.categoryNameText .becomeFirstResponder()
        
        notice = 0
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.categories.count
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = self.categories[section]
        return (self.dict[key]?.count)!
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let key = self.categories[indexPath.section]
     
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for:indexPath)
            
            cell.textLabel?.text = "Add an item"
            cell.textLabel?.textColor = UIColor.gray
            return cell
        }
        else
        {
            let item = dict[key]![indexPath.row]
            let image = item.completed ? UIImage(named: "checked")! : UIImage(named: "unchecked")!
            cell.imageView?.image = image
               
            cell.textLabel!.text = item.name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! UITableViewCell
        
        if(indexPath.row == 0)
        {
            flag.isHidden = false
            flag.categoryNameText.becomeFirstResponder()
            notice = 1
        
            let sectionHeaderView = tableView.headerView(forSection: indexPath.section)
            
            sectionTitle = (sectionHeaderView?.textLabel?.text)!
        }
        //let name = cell.textLabel?.text
        let key = self.categories[indexPath.section]
        let item = dict[key]![indexPath.row]
        
        if(indexPath.row != 0)
        {
            //let item = realm.objects(Item.self).filter("name = %@", name as Any).first
            try! self.realm.write({
                item.completed = true
            })
            
            var image: UIImage
            
            if(item.completed)
            {
                image = UIImage(named: "checked")!
            }
            else
            {
                image = UIImage(named: "unchecked")!
            }
                cell.imageView?.image = image
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            if(indexPath.row != 0)
            {
                let key = self.categories[indexPath.section]
                let item = dict[key]![indexPath.row]
                self.dict[key]?.remove(at: indexPath.row)
                try! self.realm.write({
                    self.realm.delete(item)
                })
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // Action to delete data
        }
    }
}

