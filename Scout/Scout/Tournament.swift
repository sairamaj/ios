//
//  Tournament.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 1/2/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class Tournament: PFObject, PFSubclassing {

    @NSManaged public var  Name:String!
    @NSManaged public var  Date:NSDate!
    
    var Matches:[MatchInfo] = []

    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "Tournament"
    }
}
