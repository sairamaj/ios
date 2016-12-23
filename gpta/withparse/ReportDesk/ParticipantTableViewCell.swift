//
//  ParticipantTableViewCell.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/10/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

protocol ArrivalStatusChanged{
    func onArrivalStatusChanged()
}

class ParticipantTableViewCell: UITableViewCell {

    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrivedFlag: UISwitch!
    var CurrentParticipant:Participant!
    var ShowProgramForParticipant:Bool!
    var ArrivalStatusChangedDelegate:ArrivalStatusChanged!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if( self.CurrentParticipant == nil){
            return
        }
        
        self.programNameLabel.text = ""
        if let showParticipant = self.ShowProgramForParticipant {
            if showParticipant {
                var programName = Repository.Instance.getProgramForParticipant(self.CurrentParticipant!)
                self.programNameLabel.text = "( \(programName) )"
            }
        }
        self.nameLabel.text = self.CurrentParticipant!.Name
        if( self.CurrentParticipant!.IsArrived > 0){
            self.arrivedFlag.on = true
        }else{
            self.arrivedFlag.on = false
        }
    }

    @IBAction func onArrivedFlag(sender: AnyObject) {
        self.CurrentParticipant.IsArrived = self.arrivedFlag.on ? 1: 0
        Repository.Instance.updateParticipant(self.CurrentParticipant)
        if let delegate = self.ArrivalStatusChangedDelegate{
            delegate.onArrivalStatusChanged()
        }
    }

}
