//
//  SavedOrderTableViewController.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 12/11/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

/*
    Shows orders.
 */
class SavedOrderTableViewController: UITableViewController {

    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        Repository.shared.getOrders( callback: {
            (objects) -> Void in
            
            
            for object in objects{
                self.orders.append(object)
            }
            
            self.orders = self.orders.sorted(by: { (o1, o2) -> Bool in
                o1.Date > o2.Date      })
            
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
        return self.orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderitemid", for: indexPath)

        // Configure the cell...
        let order = self.orders[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd hh:mm a"
        let dateString = dateFormatter.string(from: order.Date)

        
        cell.textLabel?.text = dateString + "     " + order.MenuItem
        return cell
    }
    
}
