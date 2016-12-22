//
//  BaseUITableViewCell.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/2/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

protocol TaskChangedDelegate{
    func TaskChanged(matchData:MatchInfo, currentCell:BaseUITableViewCell)
}

class BaseUITableViewCell: UITableViewCell {

    var Name : String = ""
    var CurrentMatchData = MatchInfo()
    var taskChangeDelegate:TaskChangedDelegate? = nil
    
    @IBOutlet weak var deviderLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        for taskSwitch in self.getAllSwitches(){
            setInitialSwitchValueFromData( taskSwitch, teamIndex: taskSwitch.teamNumber , taskName: taskSwitch.taskName)
        }

        for taskStepper in self.getAllSteppers(){
            setInitialStepperValueFromData( taskStepper, teamIndex: taskStepper.teamNumber , taskName: taskStepper.taskName)
            setStepperLimits(taskStepper, taskName: taskStepper.taskName)
            
            taskStepper.setIncrementImage(UIImage(named: "up.png"), forState: UIControlState.Normal)
            taskStepper.setDecrementImage(UIImage(named: "down.png"), forState: UIControlState.Normal)
            //[stepper setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI_2), CGAffineTransformMakeScale(0.6, 0.6))];
            // https://designcode.io/swift-design (ui related stuff)
            let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            let translate = CGAffineTransformMakeTranslation(0,100)
            let scale = CGAffineTransformMakeScale(0.9, 0.9)
            let rotateAndTranslate = CGAffineTransformConcat(translate, rotate)
            let all = CGAffineTransformConcat( rotateAndTranslate,scale )
          //  taskStepper.transform = rotateAndTranslate*/
            
            taskStepper.transform = scale
        }
        
        for taskLabels in self.getAllLabels(){
            setInitialLabelTextFromData( taskLabels, teamIndex: taskLabels.teamNumber , taskName: taskLabels.taskName)
        }
        
        for taskTextBox in self.getAllTextBoxes(){
            setInitialTextBoxValueFromData( taskTextBox, teamIndex: taskTextBox.teamNumber , taskName: taskTextBox.taskName)
        }

        if let devider = self.deviderLabel{
            devider.backgroundColor = UIColor.brownColor()
        }
        
        self.updateTotal()
    }
    
    
    @IBAction func onTaskTextBoxChanged(sender: AnyObject) {
        var taskTextBox = sender as TaskUITextField
        onTextBoxChangedChangeData(taskTextBox, teamIndex: taskTextBox.teamNumber, taskName: taskTextBox.taskName)
        
    }
    
    
    @IBAction func onTaskSwitchChanged(sender: AnyObject) {
        var taskSwitch = sender as TaskUISwitch
        onSwitchChangeChangeData(taskSwitch, teamIndex: taskSwitch.teamNumber, taskName: taskSwitch.taskName)
    }
    
    
    @IBAction func onTaskStepperValueChanged(sender: AnyObject) {
        var taskStepper = sender as TaskUIStepper
        self.onStepperChangedChangeAssociatedLabelAndData(taskStepper, teamIndex: taskStepper.teamNumber, taskName: taskStepper.taskName)
    }
    
    
    func setInitialSwitchValueFromData(ctrl:UISwitch, teamIndex: Int, taskName:String){
        if self.CurrentMatchData.TeamsTaskInfo[teamIndex].getUserEnteredValueForItem(taskName) > 0{
            ctrl.on = true
        }
    }
    
    func setInitialStepperValueFromData(ctrl:TaskUIStepper, teamIndex: Int, taskName:String){
        ctrl.value = Double(self.CurrentMatchData.TeamsTaskInfo[teamIndex].getUserEnteredValueForItem(taskName))
    }
    
    func setInitialLabelTextFromData(ctrl:TaskUILabel, teamIndex: Int, taskName:String){
        ctrl.text = String(self.CurrentMatchData.TeamsTaskInfo[teamIndex].getUserEnteredValueForItem(taskName))
    }
    
    func setInitialTextBoxValueFromData(ctrl:TaskUITextField, teamIndex: Int, taskName:String){
        var value = self.CurrentMatchData.TeamsTaskInfo[teamIndex].getUserEnteredValueForItem(taskName)
        if value > 0 {
            ctrl.text = String(self.CurrentMatchData.TeamsTaskInfo[teamIndex].getUserEnteredValueForItem(taskName))
        }
    }
    
    func onSwitchChangeChangeData(ctrl:UISwitch, teamIndex: Int, taskName:String){
        self.CurrentMatchData.TeamsTaskInfo[teamIndex].updateUserEnteredValueForItem(taskName, value: ctrl.on ? 1: 0)
        self.updateTotal()
    }
    
    func onStepperChangedChangeAssociatedLabelAndData(ctrl:TaskUIStepper, teamIndex: Int, taskName:String){
        var associatedStepperLabel = self.getTaskLabel(ctrl.taskName,teamNumber:teamIndex)
        associatedStepperLabel?.text = Int(ctrl.value).description
        self.CurrentMatchData.TeamsTaskInfo[teamIndex].updateUserEnteredValueForItem(taskName, value: Int(ctrl.value))
        self.updateTotal()
    }
    
    func onTextBoxChangedChangeData(ctrl:UITextField, teamIndex: Int, taskName:String){
        if let valueEntered = ctrl.text.toInt(){
            self.CurrentMatchData.TeamsTaskInfo[teamIndex].updateUserEnteredValueForItem(taskName, value: valueEntered)
        }else{
            self.CurrentMatchData.TeamsTaskInfo[teamIndex].updateUserEnteredValueForItem(taskName, value: 0)
        }
        self.updateTotal()
    }

    
    func updateTotal(){
        if let delegate = self.taskChangeDelegate{
            delegate.TaskChanged(self.CurrentMatchData, currentCell:self)
        }
    }
  
    func setStepperLimits(ctrl:UIStepper, taskName:String){
        ctrl.minimumValue = 0
        ctrl.maximumValue = Double(FtcScoringData.getMaximumValueForTask(taskName))
    }
    
    func getAllSwitches()->[TaskUISwitch]{
        var switches = [TaskUISwitch]()
        for child in self.subviews{
            for childchild in child.subviews{
                if( childchild is TaskUISwitch){
                    switches.append(childchild as TaskUISwitch)
                }
            }
        }
        return switches
    }
    
    func getAllSteppers()->[TaskUIStepper]{
        var steppers = [TaskUIStepper]()
        for child in self.subviews{
            for childchild in child.subviews{
                if( childchild is TaskUIStepper){
                    steppers.append(childchild as TaskUIStepper)
                }
            }
        }
        return steppers
    }
    
    func getAllLabels()->[TaskUILabel]{
        var taskLabels = [TaskUILabel]()
        for child in self.subviews{
            for childchild in child.subviews{
                if( childchild is TaskUILabel){
                    taskLabels.append(childchild as TaskUILabel)
                }
            }
        }
        return taskLabels
    }
    
    func getAllTextBoxes()->[TaskUITextField]{
        var taskTextFields = [TaskUITextField]()
        for child in self.subviews{
            for childchild in child.subviews{
                if( childchild is TaskUITextField){
                    taskTextFields.append(childchild as TaskUITextField)
                }
            }
        }
        return taskTextFields
    }
    
    func getTaskLabel(taskName:String, teamNumber:Int)->TaskUILabel?{
        var taskLabels = [TaskUILabel]()
        for child in self.subviews{
            for childchild in child.subviews{
                if( childchild is TaskUILabel){
                    var taskLabel = childchild as TaskUILabel
                    if( taskLabel.taskName == taskName && taskLabel.teamNumber == teamNumber ){
                        return taskLabel
                    }
                }
            }
        }
        return nil
    }
    
  /*  func getAllControls<T : UIControl>()->[UIControl]{
        var switches = [UIControl]()
        for child in self.subviews{
            for childchild in child.subviews{
                if( childchild is T){
                    switches.append(childchild as T)
                }
            }
        }
        return switches
    }
*/
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if let devider = self.deviderLabel{
            devider.backgroundColor = UIColor.blackColor()
        }
    }
    
}
