//
//  MenuTableViewController.swift
//  kidapp
//
//  Created by Sourabh Jamlapuram on 12/19/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuItems:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Refresh menu items.
        refresh()
        // add notification observer for Refresh.
        NotificationCenter.default.addObserver(self, selector: #selector(MenuTableViewController.onRefresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        
    }
    
    /*
     Refresh observer.
     */
    func onRefresh(){
        print("refrshing")
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuitemcellid", for: indexPath)
        
        cell.textLabel?.text = self.menuItems[indexPath.row]
        return cell
    }
    
    
    /*
     Menu item order action.
     */
    @IBAction func onOrder(_ sender: Any) {
        print("ordering...")
        if (self.tableView.indexPathForSelectedRow?.row) != nil{
            let menuItem:String = self.menuItems[(self.tableView.indexPathForSelectedRow?.row)!]
            Repository.shared.orderMenu(menuitem: menuItem)
            
            showAlert(message: menuItem + " has been ordered", title: "Order")
        }
        else{
            showAlert(message: "select a menu.", title: "Error")
        }
        
    }
    
    /*
     Alert box utility.
     */
    func showAlert(message:String, title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     Refreshes menu items.
     */
    func refresh(){
        self.menuItems.removeAll()
        Repository.shared.getMenuItems( callback: {
            (objects) -> Void in
            
            
            for object in objects{
                self.menuItems.append(object)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()    // reload in UI thread.
            }
            
        })
        
    }
}
