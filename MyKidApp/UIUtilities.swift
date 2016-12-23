//
//  UIUtilities.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/7/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class UIUtilities: NSObject {
    
    class func getActivityIndicator(view:UIView) -> UIActivityIndicatorView{
        // show activity indicator
        var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        activityIndicator.center = view.center
        activityIndicator.backgroundColor = UIColor.lightGrayColor()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return activityIndicator
    }
}
