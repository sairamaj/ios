//
//  TicketHolderTableViewController.swift
//  com.gpta
//
//  Created by Sourabh Jamlapuram on 4/13/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

extension TicketHolderTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class TicketHolderTableViewController: UITableViewController ,TaskChangedDelegate{

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var selectedRow:Int = -1
    var ticketHolders:[TicketHolder] = []
    var searchResultsForTicketHolders = [TicketHolder]()
    let searchController = UISearchController(searchResultsController: nil)
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.ticketHolders = Repository.Instance.getTicketHolders()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onTicketHoldersUpdateAvailable:"), name: NSNotificationCenterKeys().updateToTicketHoldersAvailable,object: nil)
        onRefresh(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onTicketHoldersUpdateAvailable(notification:NSNotification) {
        return
        print("update arrived\n")
        var dataUpdated = false
        
        if let dict = notification.userInfo {
            var newTicketHolders = dict["ticketHolders"] as! [TicketHolder]
            // go through them and see whether any thing is really updated
            for currentTicketHolder in self.ticketHolders{
                for newTicketHolder in newTicketHolders{
                    //print(" new updated: \(currentTicketHolder.Name) \(newTicketHolder.updatedAt!) and current: \(currentTicketHolder.updatedAt!)\n")
                    if( newTicketHolder.updatedAt! > currentTicketHolder.updatedAt!){
                        dataUpdated = true
                        currentTicketHolder.AdultsArrived = newTicketHolder.AdultsArrived
                        currentTicketHolder.KidsArrived = newTicketHolder.KidsArrived
                        
                        print("update detected:\(currentTicketHolder.Name)")
                    }
                }
            }
        }
        
        if( dataUpdated )
        {
            self.tableView.reloadData()
            self.updateTitle()
        }
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
      
        return self.getCurrentTicketHolderInfo().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ticketholdercell", forIndexPath: indexPath) as! TicketHolderCell

        var ticketHolderSource = self.getCurrentTicketHolderInfo()
        if ticketHolderSource.count < indexPath.row{
            print("prefreshed the array index problem. row is: \(indexPath.row) and ticket holder count is: \(ticketHolderSource.count)\n " )
            return cell     // safety net. todo: need to know why during refresh we are of sync.
        }
        
        cell.CurrentTicketHolder = self.getCurrentTicketHolderInfo()[indexPath.row]
        cell.tableView = self.tableView
        cell.CurrentCellRow = indexPath.row
        // Configure the cell...
        cell.taskChangeDelegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("select row\n")
        self.selectedRow = indexPath.row
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("de select row\n")
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if( indexPath.row == self.selectedRow){
            return CGFloat(250)
        }
        
        return CGFloat(50)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    func TaskChanged(ticketHolder:TicketHolder, currentCell:TicketHolderCell,isDone:Bool){
        
        if( isDone )
        {
            self.selectedRow = -1
            var indexPath = NSIndexPath(forRow: currentCell.CurrentCellRow, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            Repository.Instance.updateTicketHolder( ticketHolder )
        }
        
        self.updateTitle()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.searchResultsForTicketHolders   = self.ticketHolders.filter({( ticketHolder: TicketHolder) -> Bool in
            if (ticketHolder.Name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil){
                return true
            }
            if (ticketHolder.ConfirmationNumber.lowercaseString.rangeOfString(searchText.lowercaseString) != nil){
                return true
            }
            return false
        })

        tableView.reloadData()
    }

    func getCurrentTicketHolderInfo() -> [TicketHolder]{
        if searchController.active && searchController.searchBar.text != "" {
            return self.searchResultsForTicketHolders
        }
        return self.ticketHolders
    }
    
    func updateTitle() {
        var totalTickets:Int = 0
        var totalArrived:Int = 0
        
        for ticketHolder in self.ticketHolders{
            totalTickets += ticketHolder.AdultCount + ticketHolder.KidCount
            totalArrived += ticketHolder.AdultsArrived + ticketHolder.KidsArrived
        }
        
        self.title = String(totalArrived) + "/" + String(totalTickets)
    }
    
    @IBAction func onRefresh(sender: AnyObject) {
        var tempTicketHolders:[TicketHolder] = []
        
        self.refreshButton.enabled = false   // disable as soon as refersh is clicked
        
        self.ticketHolders.removeAll(keepCapacity: true)
            Repository.Instance.startLoadingTicketHolders ( {
                (objects) -> Void in
                
                
                for object in objects{
                    tempTicketHolders.append(object as TicketHolder)
                }
                
                tempTicketHolders.sort { $0.Name.localizedCaseInsensitiveCompare($1.Name) == NSComparisonResult.OrderedAscending}
                self.ticketHolders = tempTicketHolders
                self.tableView.reloadData()
                self.updateTitle()
                self.refreshButton.enabled = true    // enable now
            })
      
    }
}
