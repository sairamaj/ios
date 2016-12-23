//
//  ParticipantTableViewController.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/10/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ParticipantTableViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate, ArrivalStatusChanged {

    var Participants:[Participant] = []
    var filteredParticipants = [Participant]()
    var CurrentProgram:Program!
    var ShowProgramName:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let program  = self.CurrentProgram {
            self.ShowProgramName = false
        }else{
            
            self.ShowProgramName = true
            self.Participants = Repository.Instance.getParticipants()
        }
        
        self.updateTitle()
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
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredParticipants.count
        } else {
            return self.Participants.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      // todo 2016
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("participantcellidentifier", forIndexPath: indexPath) as! ParticipantTableViewCell

        if tableView == self.searchDisplayController!.searchResultsTableView {
            cell.CurrentParticipant = self.filteredParticipants[indexPath.row]
        }else{
            cell.CurrentParticipant = self.Participants[indexPath.row]
        }
        cell.ShowProgramForParticipant = self.ShowProgramName
        cell.ArrivalStatusChangedDelegate = self
        return cell

        return UITableViewCell()
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
    
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredParticipants = self.Participants.filter({( participant: Participant) -> Bool in
            if (participant.Name.lowercaseString.rangeOfString(searchText.lowercaseString) != nil){
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
        
        if let program  = self.CurrentProgram {
            title = program.Name
        }else{
            var totalParticipantsArrived:Int = 0
            var totalParticipants:Int = self.Participants.count
            
            for participant in self.Participants{
                if participant.IsArrived > 0{
                        totalParticipantsArrived++
                }
            }
            title = "Participants(\(totalParticipantsArrived)/\(totalParticipants)"
        }
    }
    
    
    func onArrivalStatusChanged(){
        self.updateTitle()
    }

}
