//
//  ActivityInstanceUITableViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/7/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ActivityInstanceUITableViewController: UITableViewController , EditActivityInstanceDoneDelegate{

    var CurrentActivity:Activity?
    var ActivityInstances:[ActivityInstance] = []
    var Child:Kid?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.ActivityInstances.count
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            var instance = self.ActivityInstances[indexPath.row]
            Instance.removeActivityInstance(self.Child!,instance: instance)
            self.load()
            self.tableView.endUpdates()
            //self.tableView.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

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

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
        var newActivityController = segue.destinationViewController as EditActivityInstanceViewController
        newActivityController.delegate = self
        
        if let rowPath = self.tableView.indexPathForSelectedRow(){
           newActivityController.CurrentActivityInstance = self.ActivityInstances[rowPath.row]
        }
    }

    func isActivityType(object:AnyObject!)->Bool{
        return false
    }
    
    func sortData(){
        
    }
    
    func load(){
        self.ActivityInstances.removeAll(keepCapacity: true)
        
        var currentActivityInstances = self.Child!.ActivityIntances.filter { (instance) -> Bool in
            return instance.ActivityId == self.CurrentActivity!.objectId && self.isActivityType(instance)
        }
        
        currentActivityInstances.forEach{ instance in  self.ActivityInstances.append(instance) }
        self.sortData()
         
    }
    
    func ActivityDone(controller: UIViewController, activityInstance: ActivityInstance , isNew:Bool){
        if isNew{
            if let kidActivityInstance = activityInstance as? KidActivityInstance{
                kidActivityInstance.KidId = self.Child!.objectId
            }
            
            activityInstance.ActivityId = self.CurrentActivity!.objectId
            Instance.saveActivityInstance(activityInstance)
            Instance.addActivityInstance(self.Child!,instance: activityInstance)
            self.ActivityInstances.append(activityInstance)
        }else{
            Instance.saveActivityInstance(activityInstance)
        }
        //  self.sortData()
        self.tableView.reloadData()
        controller.navigationController?.popViewControllerAnimated(true)
    }

}
