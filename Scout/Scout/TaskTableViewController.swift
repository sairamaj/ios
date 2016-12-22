//
//  TaskTableViewController.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/1/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

protocol ScoreDoneDelegate{
    func ScoreDone(controller: TaskTableViewController, updatedData : MatchInfo)
}

class TaskTableViewController: UITableViewController , TaskChangedDelegate{

    var SectionItems = ["Match","Autonomous","Tele-Op","End Game","General","Official"]
    let SectionSizes = [60,220,120,135,175,125]
    
    var CurrentMatchData = MatchInfo()
    var WorkingMatchData = MatchInfo()
    
    var CurrentTournament:Tournament!
    var CurrentScout:Scout!
    var delegate:ScoreDoneDelegate? = nil
    var MatchUICell:MatchUITableViewCell? = nil
    var isExisting = false
    
    var TaskSectionInfos = [String:TaskSectionInfo]()
    var TaskSectionInfoViewControls = [String:TaskSectionViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.WorkingMatchData = self.CurrentMatchData.copy() as MatchInfo
        
        if( self.WorkingMatchData.RecordBy == nil){
            self.WorkingMatchData.RecordBy = self.CurrentScout
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        for sectionItem in self.SectionItems{
            self.TaskSectionInfos[sectionItem] = TaskSectionInfo(name:sectionItem)
            switch(sectionItem.lowercaseString){
                case "match":
                    self.TaskSectionInfos[sectionItem]?.Team1Score = self.WorkingMatchData.TeamsTaskInfo[0].getTotalScore()
                    self.TaskSectionInfos[sectionItem]?.Team1Score = self.WorkingMatchData.TeamsTaskInfo[1].getTotalScore()
                    break
                default:
                    self.TaskSectionInfos[sectionItem]?.Team1Score = self.WorkingMatchData.getTeamScoreByCategory(sectionItem,teamIndex:0 )
                    self.TaskSectionInfos[sectionItem]?.Team2Score = self.WorkingMatchData.getTeamScoreByCategory(sectionItem,teamIndex:1 )
            }
        }
        
        if self.WorkingMatchData.AlianceName == nil || self.WorkingMatchData.AlianceName.isEmpty{
            self.isExisting = false
            self.WorkingMatchData.AlianceName = "red"
        }else{
           self.isExisting = true
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
        return SectionItems.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return self.SectionItems[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    override  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(self.SectionSizes[indexPath.section])
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /**
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        label.textAlignment = NSTextAlignment.Center
       // label.font = UIFont.italicSystemFontOfSize(20)
        label.backgroundColor = UIColor.lightGrayColor()
        label.textColor = UIColor.blackColor()
        label.text = self.SectionItems[section]
       // return label
        **/
        
        //
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var sectionViewController: TaskSectionViewController = storyBoard.instantiateViewControllerWithIdentifier("tasksectionviewcontrollerid") as TaskSectionViewController
        sectionViewController.Info = self.TaskSectionInfos[self.SectionItems[section]]
        sectionViewController.view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        
        self.TaskSectionInfoViewControls[self.SectionItems[section]] = sectionViewController
        
        switch( self.SectionItems[section].lowercaseString )
        {
            case "general":
                self.TaskSectionInfoViewControls[self.SectionItems[section]]?.DisableScoring = true
                self.TaskSectionInfoViewControls[self.SectionItems[section]]?.DisableDividier = true
                break
            case "official":
                self.TaskSectionInfoViewControls[self.SectionItems[section]]?.DisableScoring = true
                self.TaskSectionInfoViewControls[self.SectionItems[section]]?.DisableDividier = true
                break
        default:
            break
        }
        return sectionViewController.view
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:BaseUITableViewCell
        
        switch(indexPath.section)
        {
        case 0:
            var matchCell =  tableView.dequeueReusableCellWithIdentifier("matchcellidentifier", forIndexPath: indexPath) as MatchUITableViewCell
            matchCell.isExisting = self.isExisting
            cell = matchCell
            self.MatchUICell = matchCell
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("autonomouscellidentifier", forIndexPath: indexPath) as AutonomousTableViewCell
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("teleopcellidentifier", forIndexPath: indexPath) as TeleOpUITableViewCell
        case 3:
            cell =  tableView.dequeueReusableCellWithIdentifier("endgamecellidentifier", forIndexPath: indexPath) as EndGameUITableViewCell
        case 4:
            cell =  tableView.dequeueReusableCellWithIdentifier("generalcellidentifier", forIndexPath: indexPath) as GeneralUITableViewCell
        case 5:
            cell =  tableView.dequeueReusableCellWithIdentifier("officialcellidentifier", forIndexPath: indexPath) as OfficalTableViewCell
        default:
            return tableView.dequeueReusableCellWithIdentifier("officialcellidentifier", forIndexPath: indexPath) as OfficalTableViewCell
        }
        
        cell.taskChangeDelegate = self
        cell.CurrentMatchData = self.WorkingMatchData
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onDone(sender: AnyObject) {
        
        if !validateInputs(self.WorkingMatchData){
            return
        }
        
        self.CurrentMatchData = self.WorkingMatchData.copy() as MatchInfo
       
        if let callback = self.delegate{
            callback.ScoreDone(self, updatedData: self.CurrentMatchData)
        }
        Repository.Instance.saveMatch(self.CurrentTournament,matchInfo: self.CurrentMatchData)
    }

    func TaskChanged(matchInfo:MatchInfo, currentCell:BaseUITableViewCell){
        

        self.WorkingMatchData.update()
        self.setScoreInTitle(self.WorkingMatchData.RecordedScore)
        
        if !currentCell.Name.isEmpty{
            self.TaskSectionInfos[currentCell.Name]?.Team1Score = self.WorkingMatchData.getTeamScoreByCategory(currentCell.Name,teamIndex:0 )
            self.TaskSectionInfos[currentCell.Name]?.Team2Score = self.WorkingMatchData.getTeamScoreByCategory(currentCell.Name,teamIndex:1 )
            self.TaskSectionInfoViewControls[currentCell.Name]?.update()
            
            self.TaskSectionInfos["Match"]?.Team1Score = self.WorkingMatchData.TeamsTaskInfo[0].getTotalScore()
            self.TaskSectionInfos["Match"]?.Team2Score = self.WorkingMatchData.TeamsTaskInfo[1].getTotalScore()
            self.TaskSectionInfoViewControls["Match"]?.update()

        }
    }
    
    func setScoreInTitle(score:Int){
        self.title = "Score:"  + String(score)
    }
    	
    func validateInputs(matchInfo:MatchInfo) -> Bool
    {
        if matchInfo.MatchName == nil || matchInfo.MatchName.isEmpty {
            UserAlerts.showMessage(UserMessages().InvalidMatchNumberMessage, title: "Input")
            return false
        }
        
        if matchInfo.Team1 == 0{
            UserAlerts.showMessage(UserMessages().InvalidTeamNumber1Message, title: "Input")
            return false
        }
        
        if matchInfo.Team2 == 0{
            UserAlerts.showMessage(UserMessages().InvalidTeamNumber2Message, title: "Input")
            return false
        }
        
        return true
    }

   }
