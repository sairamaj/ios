//
//  ProgramTableViewController.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/10/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ProgramTableViewController: UITableViewController ,UISearchBarDelegate, UISearchDisplayDelegate,DetailButtonPressedDelegate{

    var Programs:[Program] = []
    var filteredPrograms = [Program]()

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBAction func onRefresh(sender: AnyObject) {
        
        self.refreshButton.enabled = false
        //Repository.Instance.loadParticipants()
        ParticipantLoader().loadParticipantswithCallback ( {
            (objects) -> Void in
            
            for object in objects{
                var participant:Participant = object as Participant
                print("refresh :\(participant.Name): \(participant.IsArrived)\n")
                Repository.Instance.updateLocalParticipant(participant, isLocalSource: false)
            }
            self.refreshButton.enabled = true
            self.tableView.reloadData()
            self.updateTitle()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.Programs = Repository.Instance.getPrograms()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onParticipantsStatusChanged:"), name: NSNotificationCenterKeys().successfullyLoadedParticipants, object: nil)
        
        let tabBarControllerItems = self.tabBarController?.tabBar.items

        if let arrayOfTabBarItems = tabBarControllerItems as! AnyObject as? NSArray{
            
            var participantTabBarItem:UITabBarItem = arrayOfTabBarItems[1] as! UITabBarItem
            participantTabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(15.0)], forState: UIControlState.Normal)
            
            var programTabBarItem:UITabBarItem = arrayOfTabBarItems[0] as! UITabBarItem
            programTabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(15.0)], forState: UIControlState.Normal)
            
        }
        self.updateTitle()
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        self.updateTitle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func onParticipantsStatusChanged(notification:NSNotification) {
        self.tableView.reloadData()
        self.updateTitle()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredPrograms.count
        } else {
            return self.Programs.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      // todo 2016
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("programcellidentifier", forIndexPath: indexPath) as! ProgramTableViewCell

        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.CurrentProgram = self.filteredPrograms[indexPath.row]
        }else{
            cell.CurrentProgram = self.Programs[indexPath.row]
        }
        cell.CurrentRow = indexPath.row
        cell.buttonPressedDelegate = self
        return cell

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if( indexPath.row == self.selectedRow){
            return CGFloat(250)
        }
        
        return CGFloat(40)
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
   // todo 2016
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        var participantController = segue.destinationViewController as! ParticipantTableViewController
       
        var selectionExists = false
        if self.searchDisplayController?.active == true{
            if let selectedRowPath  = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow(){
                var currentProgram = self.filteredPrograms[selectedRowPath.row]
                participantController.Participants = self.filteredPrograms[selectedRowPath.row].getParticipants()
                participantController.CurrentProgram = currentProgram
                selectionExists = true
            }
        }else{
            if let selectedRowPath  = self.tableView.indexPathForSelectedRow(){
                var currentProgram = self.Programs[selectedRowPath.row]
                participantController.Participants = self.Programs[selectedRowPath.row].getParticipants()
                participantController.CurrentProgram = currentProgram
                selectionExists = true
            }
        }

    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredPrograms = self.Programs.filter({( program: Program) -> Bool in
        if (program.Name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil){
                return true
            }
            return false
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func updateTitle() {
        var totalAllParticipantsArrivedForGivenProgram:Int = 0
        var totalParticipantsArrived:Int = 0
        var totalParticipants:Int = 0
        
        for program in self.Programs{
            if program.areAllParticipantsArrived(){
                totalAllParticipantsArrivedForGivenProgram++
            }
            totalParticipants += program.Participants.count
            for participant in program.Participants{
                if participant.IsArrived > 0{
                    totalParticipantsArrived++
                }
            }
        }
       
        
        self.title = "Programs(\(totalAllParticipantsArrivedForGivenProgram)/\(self.Programs.count))"
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let arrayOfTabBarItems = tabBarControllerItems as! AnyObject as? NSArray{

            var participantTabBarItem:UITabBarItem = arrayOfTabBarItems[1] as! UITabBarItem
            participantTabBarItem.title = "Participants(\(totalParticipantsArrived)/\(totalParticipants))"
    
        }
    }
    @IBOutlet weak var onDetailButton: UIButton!
    var selectedRow:Int = -1
    
    func OnClicked(program:Program, currentCell:ProgramTableViewCell, isHide:Bool){
        if isHide {
            self.selectedRow = -1
        }else{
            self.selectedRow = currentCell.CurrentRow
        }
        self.tableView.reloadData()
    }
}