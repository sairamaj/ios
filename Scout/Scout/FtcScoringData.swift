//
//  FtcScoringData.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/24/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class FtcScoringData: NSObject {
   
    var ScoreDictionary = [String:Int]()
    
    override init(){
        
        // Scores were extracted from : http://www.usfirst.org/sites/default/files/uploadedImages/Robotics_Programs/FTC/FTC_Documents_and_Updates/FTC_Game_Manual_Part_2-Rev_0_0.pdf
        // Below is the score for each task
        ScoreDictionary["AutonomousOffRamp"] = 20               // Driving from Platform On to Playing Field floor 20 points
        ScoreDictionary["AutonomousKickstandReleased"] = 30     // Releasing the Kickstand to distribute Balls 30 points
        ScoreDictionary["BallInGoals"] = 30                     // Autonomous Ball In any Rolling Goal 30 points/Goal
        ScoreDictionary["BallInCenterGoal"] = 60                // Autonomous Ball In Center Goal 60 points
        ScoreDictionary["RollingGoalsInParking"] = 20           // Moving Rolling Goal In Parking Zone 20 points/Goal
        
        
        ScoreDictionary["TeleOpRoallingGoal30CM"] = 1           // Balls Scored In 30 cm (from floor) Rolling Goal 1 point per cm
        ScoreDictionary["TeleOpRoallingGoal60CM"] = 2           // Balls Scored In 60 cm (from floor) Rolling Goal 2 points per cm
        ScoreDictionary["TeleOpRoallingGoal90CM"] = 3           // Balls Scored In 90 cm (from floor) Rolling Goal 3 points per cm
        
        ScoreDictionary["EndGameRollingGoalsInParkingZone"] = 10    // Robot / Rolling Goals In Parking Zone 10 points/item
        ScoreDictionary["EndGameGoalsOffFloor"] = 30                // Robot / Rolling Goals Completely Off the Floor 30 points/item
        ScoreDictionary["EndGameBallsInCenterGoal"] = 6             // Balls Scored In (from floor) Center Goal 6 points/cm
        ScoreDictionary["Penalty"] = 0

    }
    
    func getScoreValue(taskName:String)->Int{
        if let val =  self.ScoreDictionary[taskName]{
            return val
        }
        return 0
    }
    
    func getScoringData() ->[String:Int]{
        return self.ScoreDictionary
    }
    
    func getTasksByCategory(category:String) ->[String]{
        switch(category.lowercaseString){
            case "autonomous":
                return ["AutonomousOffRamp","AutonomousKickstandReleased", "BallInGoals", "BallInCenterGoal","RollingGoalsInParking"]
            case "tele-op":
                return ["TeleOpRoallingGoal30CM", "TeleOpRoallingGoal60CM", "TeleOpRoallingGoal90CM"]
            case "end game":
                return ["EndGameRollingGoalsInParkingZone", "EndGameGoalsOffFloor", "EndGameBallsInCenterGoal"]
        default:
                return []
        }
    }
    
    class func getMaximumValueForTask(taskName:String) -> Int{
        switch taskName{
        case "EndGameRollingGoalsInParkingZone": return 5
        case "EndGameGoalsOffFloor" : return 5
        case "RollingGoalsInParking": return 2
        case "BallInGoals" : return 3
        default:return 0
        }
    }
    
    class func isTaskCanbeDoneByTwoTeams(taskName:String)->Bool{
        var singleModeTasks = ["AutonomousOffRamp", "AutonomousKickstandReleased", "BallInCenterGoal"]
        
        for task in singleModeTasks{
            if task == taskName{
                return false
            }
        }
        return true
    }
    
    func getMaxScoreForAllianceForTask(taskName:String) -> Int?{
        switch taskName{
            case "BallInGoals": return 90
            case "RollingGoalsInParking" :return 60
            case "EndGameRollingGoalsInParkingZone": return 50
            case "EndGameGoalsOffFloor": return 150
            default:
                return nil
        }
    }

}
