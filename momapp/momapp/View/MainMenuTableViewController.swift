//
//  MainMenuTableViewController.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 12/11/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

/*
 Main menu through which Menu items and orders can be navigated.
 */
class MainMenuTableViewController: UITableViewController {

    var mainMenuItems = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mainMenuItems.append("Orders")
        mainMenuItems.append("Menu")
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
        return mainMenuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainmenuid", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = mainMenuItems[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let rowPath = self.tableView.indexPathForSelectedRow{
            if( rowPath.row == 0){
                performSegue(withIdentifier: "orderseague", sender: self)
            }else{
                performSegue(withIdentifier: "menuseague", sender: self)
            }
        }
        
    }

}
