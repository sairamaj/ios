//
//  Scout.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 1/2/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class Scout: PFObject, PFSubclassing {

    @NSManaged public var  Name:String!
    @NSManaged public var  AssociatedTeam:Int
    
    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "Scout"
    }
}
