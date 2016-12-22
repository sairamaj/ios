//
//  MatchInfoUITableViewCell.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/25/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class MatchInfoUITableViewCell: UITableViewCell {

    var CurrentMatchData: MatchInfo?
    
    
    @IBOutlet weak var matchNumberLabel: UILabel!
    @IBOutlet weak var scoutNameLabel: UILabel!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var teamScoreLabel: UILabel!
    
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var resultIndicatorView: UIView!
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    @IBOutlet weak var teamsScoreLabel: UILabel!
    @IBOutlet weak var alianceIndicatorButton: AllianceUIButton!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if( self.CurrentMatchData == nil){
            return
        }
        
        self.matchNumberLabel.text = self.CurrentMatchData?.MatchName
        self.alianceIndicatorButton.Name = self.CurrentMatchData!.AlianceName!
      
        
        if self.CurrentMatchData?.RecordBy != nil {
            self.scoutNameLabel.text = self.CurrentMatchData?.RecordBy.Name
        }else{
            self.scoutNameLabel.text = ""
        }
        self.team1Label.text = self.CurrentMatchData?.Team1.description
        self.team2Label.text = self.CurrentMatchData?.Team2.description
        var team1Score = self.CurrentMatchData?.getTeamScore(0).description
        var team2Score = self.CurrentMatchData?.getTeamScore(1).description
        self.teamsScoreLabel.text = "( " + team1Score! + "/" + team2Score! + " )"
    
        var formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"            // todo move formatter to singleton as it is costly creating a formatter.
        self.dateCreatedLabel.text = formatter.stringFromDate(self.CurrentMatchData!.MatchDate)
 
        
        if self.CurrentMatchData?.OfficialScore > 0 {
            self.teamScoreLabel.text = self.CurrentMatchData?.OfficialScore.description
        }else{
            self.teamScoreLabel.text = self.CurrentMatchData?.RecordedScore.description
        }
        
        if let result = self.CurrentMatchData?.Result{
            switch(result.uppercaseString){
                case "WON":
                    self.resultIndicatorView.backgroundColor = UIColor.greenColor()
                case "LOST":
                    self.resultIndicatorView.backgroundColor = UIColor.redColor()
            default:
                    self.resultIndicatorView.backgroundColor = UIColor.grayColor()
            }
        }else{
            self.resultIndicatorView.backgroundColor = UIColor.grayColor()
        }
    }
}
