//
//  ProgramTableViewCell.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/11/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

protocol DetailButtonPressedDelegate{
    func OnClicked(program:Program, currentCell:ProgramTableViewCell,isHide:Bool)
}

class ProgramTableViewCell: UITableViewCell {

    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var programTimeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var arrivalIndicatorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrivedCountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    @IBOutlet weak var choreographerNameLabel: UILabel!
 
    @IBOutlet weak var reportTimeLabel: UILabel!
    @IBOutlet weak var greenroomLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var programTimeInDetailLabel: UILabel!
    
    var CurrentProgram:Program!
    var buttonPressedDelegate:DetailButtonPressedDelegate!
    var CurrentRow:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onDetailButton(sender: AnyObject) {
        
        if let delegate = self.buttonPressedDelegate{
            delegate.OnClicked(self.CurrentProgram, currentCell: self, isHide:false)
            //self.detailButton.hidden = true
        }
    }
    
    @IBAction func onHideButton(sender: AnyObject) {
        
        if let delegate = self.buttonPressedDelegate{
            delegate.OnClicked(self.CurrentProgram, currentCell: self, isHide:true)
            self.detailButton.hidden = false
        }
    }
    
   
    
    override func setSelected(selected: Bool, animated: Bool) {
       // super.setSelected(selected, animated: animated)
        
        if self.CurrentProgram == nil{
            return
        }
        self.nameLabel.text = self.CurrentProgram!.Name
        if( self.CurrentProgram.areAllParticipantsArrived()){
              println("program (self.CurrentProgram!) to green")
            self.arrivalIndicatorView.backgroundColor = UIColor.greenColor()
        }else{
            println("program (self.CurrentProgram!) to red")
            self.arrivalIndicatorView.backgroundColor = UIColor.redColor()
        }
        
        self.totalLabel.text = String(self.CurrentProgram!.getTotalParticipants())
        self.arrivedCountLabel.text = String(self.CurrentProgram!.getArrivedCount())
        self.idLabel.text = String(self.CurrentProgram!.Id)
        self.programTimeLabel.text = self.CurrentProgram!.ProgramTime
        self.programTimeInDetailLabel.text = self.CurrentProgram!.ProgramTime
        self.choreographerNameLabel.text = self.CurrentProgram!.ChoreographerName
        self.reportTimeLabel.text = self.CurrentProgram!.ReportTime
        self.greenroomLabel.text = self.CurrentProgram!.GreenroomTime
        self.durationLabel.text = self.CurrentProgram!.Duration
        
      
    }

}
