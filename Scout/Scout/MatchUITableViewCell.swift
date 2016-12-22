//
//  MatchUITableViewCell.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/2/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class MatchUITableViewCell: BaseUITableViewCell ,UITextFieldDelegate{

    @IBOutlet weak var ScoutName: UITextField!
    @IBOutlet weak var MatchNumber: UITextField!
    @IBOutlet weak var MatchName: UITextField!
    @IBOutlet weak var Team1Number: UITextField!
    @IBOutlet weak var Team2Number: UITextField!
    
    
    @IBOutlet weak var AllianceIndicatorButton: AllianceUIButton!
    var isExisting:Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.AllianceIndicatorButton.layer.cornerRadius = 18;
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        
        if self.CurrentMatchData.Team1 > 0 {
            self.Team1Number.text = String(self.CurrentMatchData.Team1)
        }
        if self.CurrentMatchData.Team2 > 0 {
            self.Team2Number.text = String(self.CurrentMatchData.Team2)
        }
    
        self.MatchNumber.text = CurrentMatchData.MatchName
     

        // we use delegate to text fields to stop editing for the existing score data.
        self.Team1Number.delegate = self
        self.Team2Number.delegate = self
        self.MatchNumber.delegate = self
        
        if self.isExisting == true {
            self.Team1Number.textColor = UIColor.lightGrayColor()
            self.Team2Number.textColor = UIColor.lightGrayColor()
            self.MatchNumber.textColor = UIColor.lightGrayColor()
            self.AllianceIndicatorButton.enabled = false
        }
        
        
        if let aliasName = self.CurrentMatchData.AlianceName{
            self.AllianceIndicatorButton.Name = aliasName
        }
        
        // Configure the view for the selected state
        
    }
    
    
    @IBAction func onMatchNumberEdited(sender: AnyObject) {
            self.CurrentMatchData.MatchName = self.MatchNumber.text
            self.CurrentMatchData.TeamsTaskInfo[0].MatchName = self.MatchNumber.text
            self.CurrentMatchData.TeamsTaskInfo[1].MatchName = self.MatchNumber.text
    }


    @IBAction func onTeam1NumberEdited(sender: AnyObject) {
        if let number = self.Team1Number.text.toInt(){
            self.CurrentMatchData.Team1 = number
            self.CurrentMatchData.TeamsTaskInfo[0].TeamNumber = number
        }
    }
    
    @IBAction func onTeam2NumberEdited(sender: AnyObject) {
        if let number = self.Team2Number.text.toInt(){
            self.CurrentMatchData.Team2 = number
              self.CurrentMatchData.TeamsTaskInfo[1].TeamNumber = number
        }    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if self.isExisting {
            return false  // don't allow editing of the name,match and team numbers is already existing one.
        }
        return true
    }


    @IBAction func onAllianceIndicatorButton(sender: AnyObject) {
        self.AllianceIndicatorButton.ToggleName()
        self.CurrentMatchData.AlianceName = self.AllianceIndicatorButton.Name
    }
    
    
    
   
}
