//
//  NewHomeClassActivityUIViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/6/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


class EditHomeClassActivityUIViewController: EditActivityInstanceViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let homeClassActivityInstance = self.CurrentActivityInstance as? HomeClassActivityInstance{
            self.titleText.text = homeClassActivityInstance.Title
            self.notesTextView.text = homeClassActivityInstance.Notes
            
        }
        
        if self.isNew == false {
            self.titleText.enabled = false
            self.datePicker.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        var activity = self.CurrentActivityInstance as? HomeClassActivityInstance
            
        if activity == nil{
            activity = HomeClassActivityInstance()
            activity!.Date = self.datePicker.date
            activity!.Title = self.titleText.text
        }
        activity!.Notes = self.notesTextView.text

        self.delegate!.ActivityDone( self, activityInstance: activity!, isNew: self.isNew)
       
    }
    
  

}
