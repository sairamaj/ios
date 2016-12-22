//
//  SavedScoutTableViewController.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 11/30/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class SavedScoutTableViewController: UITableViewController ,ScoreDoneDelegate, UISearchBarDelegate, UISearchDisplayDelegate{

    var ScoutsData = [ScoutData]()
    var AllMatchesForTournament = [MatchInfo]()
    var MatchData = [MatchInfo]()
    var filteredMatches = [MatchInfo]()
    
    var CurrentTournament :Tournament!
    var CurrentScout:Scout!
    var busyIndicator:BusyIndicator!
    var isNew:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

            
        Repository.Instance.loadMatches(self.CurrentTournament!)
        // todo: convert to blocked api: http://moreindirection.blogspot.com/2014/08/nsnotificationcenter-swift-and-blocks.html
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDataLoadedSuccesssfully:"), name: NSNotificationCenterKeys().successfullyLoadedTournamentMatches, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("OnMatchRecordByLoadedSuccessfully:"), name: NSNotificationCenterKeys().successfullyLoadedMatchRecordBy, object: nil)
       
        var formatter = NSDateFormatter()
        formatter.dateFormat = "E MMM dd"            // todo move formatter to singleton as it is costly creating a formatter.
        var tournamentDate = formatter.stringFromDate(self.CurrentTournament!.Date)
        self.title = self.CurrentTournament!.Name + "(" + tournamentDate + ")" + "-" + self.CurrentScout!.AssociatedTeam.description
        
        // show activity indicator
        if self.isNew == false{
            self.busyIndicator = BusyIndicator(parent:self.view)
            self.busyIndicator.start()
        }

    }

    func onDataLoadedSuccesssfully(notification:NSNotification) {
        self.AllMatchesForTournament = notification.object as [MatchInfo]
        self.busyIndicator?.stop()
    }
    
    func OnMatchRecordByLoadedSuccessfully(notification:NSNotification){
        var matchLoaded = notification.object as MatchInfo
        if matchLoaded.RecordBy!.AssociatedTeam != self.CurrentScout!.AssociatedTeam{
            return
        }
        self.MatchData.append(matchLoaded)
        self.sortScoutData()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredMatches.count
        } else {
            return self.MatchData.count
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // var cell1 = tableView.dequeueReusableCellWithIdentifier("matchdatacellidentifier", forIndexPath: indexPath)
        let cell = self.tableView.dequeueReusableCellWithIdentifier("matchdatacellidentifier", forIndexPath: indexPath) as MatchInfoUITableViewCell

        if tableView == self.searchDisplayController!.searchResultsTableView {
            var matchData = self.filteredMatches[indexPath.row]
            cell.CurrentMatchData = matchData

        }else{
            var matchData = self.MatchData[indexPath.row]
            cell.CurrentMatchData = matchData
        }
         return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            var matchDataTobeDeleted = self.MatchData.removeAtIndex(indexPath.row)
            Repository.Instance.deleteMatch(matchDataTobeDeleted)
            self.tableView.reloadData()
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        /*var navigationController = segue.destinationViewController as UINavigationController
        
        var taskController = navigationController.childViewControllers[0] as TaskTableViewController*/
        
        var taskController = segue.destinationViewController  as TaskTableViewController
        taskController.delegate = self
        
        if self.searchDisplayController?.active == true{
            if let selectedRowPath  = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow(){
                var matchData = self.filteredMatches[ selectedRowPath.row ]
                taskController.CurrentMatchData = matchData
            }
        }else{
            if let selectedRowPath  = self.tableView.indexPathForSelectedRow(){
                var matchData = self.MatchData[ selectedRowPath.row ]
                taskController.CurrentMatchData = matchData
           }
        }
        taskController.CurrentTournament = self.CurrentTournament
        taskController.CurrentScout = self.CurrentScout
    }
    
    func ScoreDone(controller: TaskTableViewController, updatedData : MatchInfo ) {
        controller.navigationController?.popViewControllerAnimated(true)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var found = false
            for (index,val) in enumerate(self.MatchData){
                if( val.getKey() == updatedData.getKey()){
                    self.MatchData[index] = updatedData
                    found = true
                    break
                }
            }
            if !found{
                println("not found means new one")
                self.MatchData.append(updatedData)
            }
            self.sortScoutData()
            self.tableView.reloadData()
        })
    }
    
    func sortScoutData(){
       // self.ScoutsData.sort() { $0.TeamNumber < $1.TeamNumber }      // sorting arrary on the team number.
        
        //self.ScoutsData.sort( { (s1:ScoutData, s2:ScoutData) -> Bool in String(s1.TeamNumber) + String(s1.MatchNumber) < String(s2.TeamNumber) + String(s2.MatchNumber)} )
        self.MatchData.sort( { (s1:MatchInfo, s2:MatchInfo) -> Bool in  s1.MatchDate < s2.MatchDate } )
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredMatches = self.MatchData.filter({( match: MatchInfo) -> Bool in
            if (match.Team1.description.rangeOfString(searchText) != nil){
                return true
            }
            if (match.Team2.description.rangeOfString(searchText) != nil){
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
}
