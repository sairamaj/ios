//
//  UserAlerts.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 1/3/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class UserAlerts: NSObject {
    
    class func showMessage(msg:String, title:String)
    {
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("OK");
        alertView.title = title;
        alertView.message = msg;
        alertView.show();
        
        // UIAlertController is for ios 8 only and crashes if the device is less than 8.
        /* var alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)*/
    }
    
    class func showMessageForNoNetwork(){
        UserAlerts.showMessage("No network is available and data cannot be saved. You can use the app but once you quit the data will be lost.Enable either wifi or cellular in order for the scout data to saved in the cloud.", title: "Warning")
    }
    
}
