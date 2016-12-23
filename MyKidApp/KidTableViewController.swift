//
//  KidTableViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 11/27/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


class KidTableViewController: UITableViewController {

    var kids:[Kid] = []
    var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.activityIndicator = UIUtilities.getActivityIndicator(self.view)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onDataLoadedSuccesssfully", name: NSNotificationCenterKeys().dataLoadedSuccessfully, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKidUpdatedAdded:", name: NSNotificationCenterKeys().kidUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKidUpdatedAdded:", name: NSNotificationCenterKeys().kidAdded, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKidUpdatedAdded:", name: NSNotificationCenterKeys().kidDeleted, object: nil)
    }

    func onDataLoadedSuccesssfully() {
        self.kids = Instance.Kids
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    func onKidUpdatedAdded(notification:NSNotification){
        self.kids = Instance.Kids
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.kids.count
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return self.kids[section].Name
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var kid = self.kids[section]
        return kid.Activities2.count
    }

/*    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
    return [animalSectionTitles objectAtIndex:section];
    }
*/

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("kidtableviewidentifier", forIndexPath: indexPath) as KidTableViewCell

        var kid = self.kids[indexPath.section]
        cell.textLabel?.text = kid.Activities2[indexPath.row].Name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var kid = self.kids[section]
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 36) )
        
        let label = UILabel(frame: CGRect(x: 65, y: 0, width: tableView.bounds.width, height: 36))
        label.textAlignment = NSTextAlignment.Left
        // label.font = UIFont.italicSystemFontOfSize(20)
        //label.backgroundColor = UIColor.lightGrayColor()
        label.textColor = UIColor.blackColor()
        label.text = kid.Name
        view.addSubview(label)
        
        var imageView = UIImageView(frame: CGRect(x: 10, y: 2, width: 40, height: 46))
        if let image = kid.ThumbnailImage{
            imageView.image = image
        }
        view.addSubview(imageView)
        return view
    }

    override func tableView(tableView:UITableView, heightForHeaderInSection section:Int)->CGFloat{
        return 60
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let selectedRowPath  = self.tableView.indexPathForSelectedRow(){
            var currentActivity = self.kids[selectedRowPath.section].Activities2[selectedRowPath.row]
            self.performSegueWithIdentifier( "activity_seague", sender: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
                   // Get the new view controller using [segue destinationViewController].
            // Pass the selected object to the new view controller.
            var activityViewController = segue.destinationViewController as ActivityTableViewController
        
            var selectedRow = self.tableView.indexPathForSelectedRow()
            // get the category selected and then get the activities for the selected category.
            if let selectedRowPath  = self.tableView.indexPathForSelectedRow(){
                activityViewController.CurrentActivity = self.kids[selectedRowPath.section].Activities2[selectedRowPath.row]
                
                //activityViewController.Activities = currentActivity.SubActivities
                activityViewController.Child = self.kids[selectedRowPath.section]
                //  activityViewController.Category = currentCategory
            }
    }
    
    
   /* override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.orangeColor()
    }*/
    

 
}
