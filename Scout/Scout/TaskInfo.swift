//
//  ScoutDataKeeper.swift
//  ScoutAppV1_Beta
//
//  Created by Sneha Malineni on 11/15/14.
//  Copyright (c) 2014 Sneha Malineni. All rights reserved.
//

import UIKit

public class ScoutData : PFObject, PFSubclassing, NSCopying{
    
    // This is the user entered values . For autonomous switches it is 1 or 0
    var UserEnteredItems = [String:Int]()
    
    @NSManaged public var  TeamNumber:Int
    @NSManaged public var  MatchName:String!
    @NSManaged public var  Data:String!
    
   // var Comment:String = ""
    //var pfObjectId:String?
    var FtcScoreData = FtcScoringData()

    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "TeamTask"
    }
    
  
    override init (){
        
        super.init()
        
        // Here is the user entered values which starts with 0
        UserEnteredItems["AutonomousOffRamp"] = 0
        UserEnteredItems["AutonomousKickstandReleased"] = 0
        UserEnteredItems["BallInCenterGoal"] = 0
        
        
        UserEnteredItems["BallInGoals"] = 0
        UserEnteredItems["RollingGoalsInParking"] = 0
        UserEnteredItems["TeleOpRoallingGoal30CM"] = 0
        UserEnteredItems["TeleOpRoallingGoal60CM"] = 0
        UserEnteredItems["TeleOpRoallingGoal90CM"] = 0
        UserEnteredItems["EndGameRollingGoalsInParkingZone"] = 0
        UserEnteredItems["EndGameGoalsOffFloor"] = 0
        UserEnteredItems["EndGameBallsInCenterGoal"] = 0
        UserEnteredItems["Penalty"] = 0
        
    }
    
    /*
    update the user entered values
    for ex: if the user changes switch A1 then      UserEnteredItems["A1"] = 1  // for switches it is 1 or 0
    if the user enteres some value for B1    UserEnteredItems["A1"] = 5  // 5 is the entered in text field
    
    */
    func updateUserEnteredValueForItem(name:String, value:Int){
        UserEnteredItems[name] = value
    }
    
    /*
    gets the total score
    */
    func getTotalScore() -> Int{
        var score = 0
        
        for (name,val) in self.UserEnteredItems{
                score += FtcScoreData.getScoreValue(name) * val        // multiply the score with user entered value.
        }
        return score
    }
    
    /*
    gets the values as CSV
    returns A1,20,A2,30 ....
    */
    func getItemValuesAsCSV() -> String{
        var csvValue:String = ""
        
        let sortedKeys = Array(self.UserEnteredItems.keys).sorted(<)
        
        for key in sortedKeys{
            csvValue = csvValue + key + ","
            var itemValue = getUserEnteredValueForItem(key)
            var scoreForThisItem = self.FtcScoreData.getScoreValue(key) * itemValue
            csvValue = csvValue + String(scoreForThisItem)
            csvValue = csvValue + ","
        }
        
        return csvValue
    }
    
    /*
    gets the user entered value which was stored in dictonary. "A1" returns 1 if switch is ON
    */
    func getUserEnteredValueForItem(item:String) -> Int{
        if let val = UserEnteredItems[item] {
            return val
        }
        return 0
    }
    
    func getKey()->String{
        return String(self.TeamNumber) + "_" + self.MatchName
    }
    
    func parseCSV(key:String, data:String){
        var csvParts = split(data) {$0 == ","}
        for (index, part) in enumerate(csvParts) {
            if index % 2 == 0 {
                var itemValue = self.FtcScoreData.getScoreValue(part)
                if itemValue > 0 {
                    var totalValue = csvParts[index+1].toInt()
                    var actualValue = totalValue! / itemValue
                    self.UserEnteredItems[part] = actualValue
                }
            }
        }
    }

    public func copyWithZone(zone: NSZone) -> AnyObject {
        
        var copy = ScoutData()

        copy.MatchName = self.MatchName
        copy.TeamNumber = self.TeamNumber

        for (key,val) in self.UserEnteredItems{
            copy.UserEnteredItems[key] = val
        }
        
        copy.Data = self.Data
        
        copy.objectId = self.objectId
        return copy
    }
    
    func update(){
        self.Data = self.getItemValuesAsCSV()
    }
    
    func load(){
        self.parseCSV("", data: self.Data)
    }
}

