//
//  TournamentMatch.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 1/2/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class TournamentMatchXX: PFObject, PFSubclassing {
    
    @NSManaged public var  Date:NSDate!
    
    var Match: MatchInfo!
    var AssociatedScout: Scout!
    
    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "TournamentMatch"
    }
}
