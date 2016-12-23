//
//  VocabularyUITableViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/7/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


class VocabularyUITableViewController: ActivityInstanceUITableViewController {


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vocabularycellidentifier", forIndexPath: indexPath) as UITableViewCell

        var activityInstance = self.ActivityInstances[indexPath.row] as VocabularyActivityInstance
        cell.textLabel?.text = activityInstance.Word

        return cell
    }


    
    override func isActivityType(object:AnyObject!)->Bool{
        return object is VocabularyActivityInstance
    }

}
