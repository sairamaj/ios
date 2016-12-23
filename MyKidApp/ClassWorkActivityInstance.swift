//
//  ClassWorkActivityInstance.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/15/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class ClassWorkActivityInstance: KidActivityInstance {
    
    @NSManaged public var Date:NSDate
    @NSManaged public var Notes:String
    
    
    override init(){
        super.init()
        self.Type = "classwork"
    }
    
    override public class func load() {
        registerSubclass()
    }
    
    public override class func parseClassName() -> String! {
        return "ClassWorkActivityInstance"
    }

}
