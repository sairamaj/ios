//
//  ActivityTableViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 11/27/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController {

    var Activities:[Activity] = []
    var CurrentActivity:Activity?
   // var ActualActivities:[Activity] = []

    var Child:Kid?
    var isContainerActivity:Bool = false
    

    var repository:RepositoryProtocol = RepsitoryFactory.get()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // get only activities which does have some sub activities
       // self.ActualActivities = self.Activities.filter { (activity) -> Bool in
      //      activity.SubActivities.count > 0
      //  }
        self.Activities = self.CurrentActivity!.SubActivities
        
        self.isContainerActivity = self.Activities.any { (activity) -> Bool in
            return activity.SubActivities.count > 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if self.isContainerActivity {
            return self.Activities.count
        }
        return 1
   
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if self.isContainerActivity{
            return self.Activities[section].Name
        }
        return nil
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isContainerActivity{
            return self.Activities[section].SubActivities.count
        }
        return self.Activities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        if self.isContainerActivity{
            cell.textLabel?.text = self.Activities[indexPath.section].SubActivities[indexPath.row].Name
        }else{
            cell.textLabel?.text = self.Activities[indexPath.row].Name
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var activity:Activity? = nil
        
        if self.isContainerActivity{
            activity = self.Activities[indexPath.section].SubActivities[indexPath.row]
        }else{
            activity = self.Activities[indexPath.row]
        }
        
        self.performSegueWithIdentifier( ActivitySeagueMap.getSeague(activity!.Type!), sender: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var activity:Activity?
        
        if let rowPath = self.tableView.indexPathForSelectedRow(){
            if self.isContainerActivity{
                activity = self.Activities[rowPath.section].SubActivities[rowPath.row]
            }else{
                activity = self.Activities[rowPath.row]
            }
        }
        
        var activityController = segue.destinationViewController as ActivityInstanceUITableViewController
        activityController.Child = self.Child!
        activityController.CurrentActivity = activity

    }
    

}
