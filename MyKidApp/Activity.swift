//
//  Activity.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/10/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class Activity:  PFObject,PFSubclassing {
    @NSManaged public var  Name:String
    @NSManaged public var  ParentId:String?
    @NSManaged public var  Type:String?
    var SubActivities:[Activity] = []
    
    override init(){
        super.init()
    }
    
    init(name:String){
        super.init()
        self.Name = name
    }
    
    init(name:String,subactivities:[Activity]){
        super.init()
        self.Name = name
        self.SubActivities = subactivities
    }
    
    func addSubActivity(activity:Activity){
        self.SubActivities.append(activity)
    }
    
    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "Activity"
    }
}
