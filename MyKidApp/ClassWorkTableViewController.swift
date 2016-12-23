//
//  ClassWorkTableViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/15/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ClassWorkTableViewController: ActivityInstanceUITableViewController {

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("classworkcellidentifier", forIndexPath: indexPath) as ClassWorkTableViewCell
        
        
        cell.ActivityInstance = self.ActivityInstances[indexPath.row] as? ClassWorkActivityInstance
        
        return cell
    }
  
    override func isActivityType(object:AnyObject!)->Bool{
        return object is ClassWorkActivityInstance
    }
}
