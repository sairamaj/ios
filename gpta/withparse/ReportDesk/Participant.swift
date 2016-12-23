//
//  Participant.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/10/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit
import Parse


public class Participant: PFObject, PFSubclassing  {
    @NSManaged var Name:String!
    @NSManaged var Id:Int
    @NSManaged var IsArrived:Int

    
    override public class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }

    public static func parseClassName() -> String {
        return "Participant"
    }

}
