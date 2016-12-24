//
//  MenuTableViewController.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 12/13/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

/*
 Shows menu items.
 */
class MenuTableViewController: UITableViewController , MenuItemAddedDelegate{

    var menuItems:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        Repository.shared.getMenuItems( callback:    {
            (objects) -> Void in
            
            
            for object in objects{
                self.menuItems.append(object)
            }
            self.sortMenuItems()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()    // reload in UI thread.
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuitemcellid", for: indexPath)

        cell.textLabel?.text = menuItems[indexPath.row]

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let menuItem = menuItems[indexPath.row]
             self.menuItems.remove(at: indexPath.row)
            Repository.shared.removeMenuItem(menuitem: menuItem)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var addMenuItemController = segue.destination  as! AddMenuItemViewController
        addMenuItemController.curentMenuItems = self.menuItems
        addMenuItemController.delegate = self
    }
 

    @IBAction func onAdd(_ sender: Any) {
        let popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addmenuitemstoryboard")
      //  popup.modalPresentationStyle = UIModalPresentationStyle.popover
        self.addChildViewController(popup)
        popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        popup.didMove(toParentViewController: self)
        
    }
    
    func MenuItemAdded(menuItem:String){
        self.menuItems.append(menuItem)
        self.sortMenuItems()
        DispatchQueue.main.async {
            self.tableView.reloadData()    // reload in UI thread.
        }
    }
    
    func sortMenuItems() -> Void{
        self.menuItems = self.menuItems.sorted(by: { (s1, s2) -> Bool in
            s1.localizedCompare(s2)  == ComparisonResult.orderedAscending      })
        
    }
}
