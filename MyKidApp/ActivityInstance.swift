//
//  ActivityInstance.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/21/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class ActivityInstance: PFObject,PFSubclassing {
    @NSManaged public var  Type:String
    @NSManaged public var ActivityId:String

    
    override init(){
        super.init()
     }
    
    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "ActivityInstance"
    }
}
