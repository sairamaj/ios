//
//  EditVocabularyViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/7/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit



class EditVocabularyViewController: EditActivityInstanceViewController, UITextFieldDelegate {

        
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var meaningTextField: UITextView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vocabularyInstance = self.CurrentActivityInstance as? VocabularyActivityInstance{
            self.wordTextField.text = vocabularyInstance.Word
            self.meaningTextField.text = vocabularyInstance.Meaning
        }
        
        if self.isNew == false {
            self.wordTextField.textColor = UIColor.lightGrayColor()
            self.meaningTextField.textColor = UIColor.lightGrayColor()
        }

    }
    
    @IBAction func onDone(sender: AnyObject) {
        var newActivity = VocabularyActivityInstance()
        newActivity.Word = self.wordTextField.text
        newActivity.Meaning = self.meaningTextField.text
        if( self.delegate != nil)
        {
            self.delegate!.ActivityDone( self, activityInstance: newActivity, isNew: self.isNew)
        }
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if self.isNew {
            return true
        }
        return false // don't allow editing of the name,match and team numbers is already existing one.
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
