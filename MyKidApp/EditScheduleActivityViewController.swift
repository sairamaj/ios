//
//  NewScheduleActivityViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/21/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


class EditScheduleActivityViewController: EditActivityInstanceViewController {

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var activityDatePicker: UIDatePicker!
      
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let scheduleActivityInstance = self.CurrentActivityInstance as? ScheduleActivityInstance{
            self.notesTextView.text = scheduleActivityInstance.Notes
            self.activityDatePicker.date = scheduleActivityInstance.Date
        }

    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onDone(sender: AnyObject) {
        
        var activity = self.CurrentActivityInstance as? ScheduleActivityInstance
        
        if activity == nil{
            activity = ScheduleActivityInstance()
        }
        activity!.Date = self.activityDatePicker.date
        activity!.Notes = self.notesTextView.text
        if( self.delegate != nil)
        {
            self.delegate!.ActivityDone( self, activityInstance: activity! , isNew: self.isNew)
        }
    }

}
