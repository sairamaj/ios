//
//  BusyIndicator.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 2/16/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class BusyIndicator: NSObject {

    var activityIndicator:UIActivityIndicatorView!
    var parent:UIView!
    
    init(parent:UIView){
        self.parent = parent
        super.init()
    }
    
    func start(){
        if( Reachability.reachabilityForInternetConnection().isReachable() == false){
            return  // if no network then dont even start.
        }
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        self.activityIndicator.center = self.parent.center
        self.activityIndicator.backgroundColor = UIColor.lightGrayColor()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.parent.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    func stop(){
        if self.activityIndicator == nil{
            return
        }
        self.activityIndicator.stopAnimating()
    }
    

}
