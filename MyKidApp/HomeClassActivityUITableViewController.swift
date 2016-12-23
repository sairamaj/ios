//
//  HomeClassActivityUITableViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/6/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class HomeClassActivityUITableViewController: ActivityInstanceUITableViewController{


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeclassidentifier", forIndexPath: indexPath) as UITableViewCell

        var activityInstance = self.ActivityInstances[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = (activityInstance as HomeClassActivityInstance).Title
        return cell
    }
    

    override func isActivityType(object:AnyObject!)->Bool{
        return object is HomeClassActivityInstance
    }

}
