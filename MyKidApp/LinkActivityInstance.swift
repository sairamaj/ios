//
//  LinkActivityInstance.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/22/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


public class LinkActivityInstance: ActivityInstance {
    
    @NSManaged public var Url:String
    
    override public class func load() {
        registerSubclass()
    }
    
    public override class func parseClassName() -> String! {
        return "LinkActivityInstance"
    }
}