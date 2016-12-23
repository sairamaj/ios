//
//  ActivitySeagueMap.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/11/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ActivitySeagueMap: NSObject {
    class func getSeague(activity:String) ->String{
        switch(activity){
                case "schedule":
                        return "scheduleactivity_seague"
                case "homeclass":
                        return "homeclassactivity_seague"
                case "vocabulary":
                        return "vocabulary_seague"
                case "classwork":
                        return "classworkactivity_seague"
                default: return "favorites_seague"
        }
    }
}
