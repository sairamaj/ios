//
//  TicketHolderCell.swift
//  com.gpta
//
//  Created by Sourabh Jamlapuram on 4/13/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

protocol TaskChangedDelegate{
    func TaskChanged(ticketHolder:TicketHolder, currentCell:TicketHolderCell, isDone: Bool)
}

class TicketHolderCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var arrivalIndicatorView: UIView!
    @IBOutlet weak var ticketInfoLabel: UILabel!
    @IBOutlet weak var aduitArrivedTextField: UITextField!
    @IBOutlet weak var kidsArrivedTextField: UITextField!
    @IBOutlet weak var adultCountTextField: UILabel!
    @IBOutlet weak var kidCountTextField: UILabel!
    @IBOutlet weak var allArrivedSwitch: UISwitch!
    @IBOutlet weak var ticketHolderIdLabel: UILabel!
    @IBOutlet weak var kidsStepper: UIStepper!
    @IBOutlet weak var adultStepper: UIStepper!
    @IBOutlet weak var confirmationNumberLabel: UILabel!
    var taskChangeDelegate:TaskChangedDelegate? = nil
    
    var CurrentTicketHolder:TicketHolder!
    var CurrentCellRow:Int!
    var tableView:UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        if self.CurrentTicketHolder == nil{
            return
        }
        
        self.name.text = self.CurrentTicketHolder.Name
        self.aduitArrivedTextField.text = String(self.CurrentTicketHolder.AdultsArrived)
        self.adultCountTextField.text = String(self.CurrentTicketHolder.AdultCount)
        self.kidsArrivedTextField.text = String(self.CurrentTicketHolder.KidsArrived)
        self.kidCountTextField.text = String(self.CurrentTicketHolder.KidCount)
        self.confirmationNumberLabel.text = self.CurrentTicketHolder.ConfirmationNumber
        self.aduitArrivedTextField.enabled = false
        self.kidsArrivedTextField.enabled = false
        self.ticketHolderIdLabel.text = String(self.CurrentTicketHolder.Id)
        
        self.setStepperValues()
        self.UpdateArrivedStatuses()
        
    }

    @IBAction func onAllArrivedSwitch(sender: AnyObject) {
        self.CurrentTicketHolder.markAllArrived()
        self.sendNotification(true)
    }
    
    @IBAction func onDone(sender: AnyObject) {
        self.sendNotification(true)
    }
    
    func setStepperValues(){
        self.adultStepper.minimumValue = 0
        self.adultStepper.maximumValue = Double(self.CurrentTicketHolder.AdultCount)
        self.adultStepper.value = Double(self.CurrentTicketHolder.AdultsArrived)
        
        self.kidsStepper.minimumValue = 0
        self.kidsStepper.maximumValue = Double(self.CurrentTicketHolder.KidCount)
        self.kidsStepper.value = Double(self.CurrentTicketHolder.KidsArrived)
    }
    
    @IBAction func onAdultStepper(sender: AnyObject) {
        self.aduitArrivedTextField.text = String( Int(self.adultStepper.value))
        self.CurrentTicketHolder.AdultsArrived = Int(self.adultStepper.value)
        self.UpdateArrivedStatuses()
    }
    
    @IBAction func onKidStepper(sender: AnyObject) {
        self.kidsArrivedTextField.text = String( Int(self.kidsStepper.value))
        self.CurrentTicketHolder.KidsArrived = Int(self.kidsStepper.value)
        self.UpdateArrivedStatuses()
    }
    
    func UpdateArrivedStatuses() ->Void{
        self.ticketInfoLabel.text = String(self.CurrentTicketHolder.getTotalArrived()) + "/" + String(self.CurrentTicketHolder.getTotalTickets())
        
        self.allArrivedSwitch.setOn(false, animated: false)
        self.allArrivedSwitch.enabled = true
        switch self.CurrentTicketHolder.getArrivalStatus(){
        case .NoneArrived:
            self.arrivalIndicatorView.backgroundColor = UIColor.redColor()
        case .PartialArrived:
            self.arrivalIndicatorView.backgroundColor = UIColor.purpleColor()
        case .AllArrived:
            self.arrivalIndicatorView.backgroundColor = UIColor.greenColor()
            self.allArrivedSwitch.setOn(true, animated: false)
            self.allArrivedSwitch.enabled = false
        }
    }
    
    func sendNotification(isDone:Bool){
        if let delegate = self.taskChangeDelegate{
            delegate.TaskChanged(self.CurrentTicketHolder, currentCell:self, isDone: isDone)
        }
    }
}
