//
//  ScheduleActivityInstance.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/22/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class ScheduleActivityInstance: KidActivityInstance {
    
   
    @NSManaged public var Date:NSDate
    @NSManaged public var Notes:String

    
    override init(){
        super.init()
        self.Type = "schedule"
    }
    
    override public class func load() {
        registerSubclass()
    }
    
    public override class func parseClassName() -> String! {
        return "ScheduleActivityInstance"
    }
}
