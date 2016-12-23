//
//  EditActivityInstanceViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/7/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class EditActivityInstanceViewController: UIViewController {

    var delegate:EditActivityInstanceDoneDelegate? = nil
    var CurrentActivityInstance: ActivityInstance!
    var isNew = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.CurrentActivityInstance != nil{
            self.isNew = false
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

}
