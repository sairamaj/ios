//
//  TaskSectionViewController.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 2/2/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class TaskSectionViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    @IBOutlet weak var dividierLabel: UILabel!
    
    private var disableScoring:Bool = false
    var DisableScoring:Bool{
        get{
            return self.disableScoring
        }
        set(value){
            self.disableScoring = value
        }
    }
    
    private var disableDivider:Bool = false
    var DisableDividier:Bool{
        get{
            return self.disableDivider
        }
        set(value){
            self.disableDivider = value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.update()
        
    }
    
    private var info:TaskSectionInfo! = nil
    var Info:TaskSectionInfo!{
        set(value){
            self.info = value
        }
        get{
            return self.info
        }
    }
    
    func update(){
        self.nameLabel.text = self.info.Name

        if self.disableScoring{
            self.team1ScoreLabel.text = ""
            self.team2ScoreLabel.text = ""
        }else{
            self.team1ScoreLabel.text = String(self.info.Team1Score)
            self.team2ScoreLabel.text = String(self.info.Team2Score)
        }
        
        if( self.info.Team1Score > self.info.Team2Score){
            self.team1ScoreLabel.textColor = UIColor.greenColor()
            self.team2ScoreLabel.textColor = UIColor.redColor()
        }else if( self.info.Team1Score < self.info.Team2Score ){
            self.team1ScoreLabel.textColor = UIColor.redColor()
            self.team2ScoreLabel.textColor = UIColor.greenColor()
        }else{
            self.team1ScoreLabel.textColor = UIColor.blueColor()
            self.team2ScoreLabel.textColor = UIColor.blueColor()
        }
        self.dividierLabel.hidden = self.disableDivider
    }
}
