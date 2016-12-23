//
//  HomeClassActivityInstance.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/6/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class HomeClassActivityInstance: KidActivityInstance {
   
    @NSManaged public var Date:NSDate
    @NSManaged public var Title:String
    @NSManaged public var Notes:String    
    
    override init(){
        super.init()
        self.Type = "homeclass"
    }
    
    override public class func load() {
        registerSubclass()
    }
    
    public override class func parseClassName() -> String! {
        return "HomeClassActivityInstance"
    }
    
}
