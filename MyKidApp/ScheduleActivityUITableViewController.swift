//
//  ScheduleActivityUITableViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/21/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ScheduleActivityUITableViewController: ActivityInstanceUITableViewController{

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scheduleactivitycellidentifier", forIndexPath: indexPath) as ScheduleActivityUITableViewCell

        // Date format strings: http://waracle.net/iphone-nsdateformatter-date-formatting-table/
        // Configure the cell...
        
        cell.ActivityInstance = self.ActivityInstances[indexPath.row] as? ScheduleActivityInstance
        
        return cell
    }

    override func sortData(){
        self.ActivityInstances.sort( { (s1:ActivityInstance, s2:ActivityInstance
            ) -> Bool in (s2 as ScheduleActivityInstance).Date.compare((s1 as ScheduleActivityInstance).Date) == NSComparisonResult.OrderedDescending} )
    }

    override func isActivityType(object:AnyObject!)->Bool{
        return object is ScheduleActivityInstance
    }

    
}
