//
//  EditClassWorkViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/15/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class EditClassWorkViewController: EditActivityInstanceViewController {

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDone(sender: AnyObject) {
        var activity = self.CurrentActivityInstance as? ClassWorkActivityInstance
        
        if activity == nil{
            activity = ClassWorkActivityInstance()
        }
        activity!.Date = self.datePickerView.date
        activity!.Notes = self.notesTextView.text
        if( self.delegate != nil)
        {
            self.delegate!.ActivityDone( self, activityInstance: activity! , isNew: self.isNew)
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

}
