//
//  MatchInfo.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/24/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


public class MatchInfo: PFObject, PFSubclassing, NSCopying{
   
    @NSManaged public var  AlianceName:String!
    @NSManaged public var  MatchName:String!
    @NSManaged public var  Team1:Int
    @NSManaged public var  Team2:Int
    @NSManaged public var  RecordedScore:Int
    @NSManaged public var  OfficialScore:Int
    @NSManaged public var  Result:String!
    @NSManaged public var  Comment:String!
    
    var PsedoCreatedDate =  NSDate()        // date only to keep track for the new record as createAt will not exists until the record is saved.
    
    
    var RecordBy:Scout!

    var TeamsTaskInfo = [ScoutData(),ScoutData()]
    
    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "Match"
    }
    
    var MatchDate:NSDate{
        get{
            if self.createdAt == nil {
                return PsedoCreatedDate
            }else{
                return self.createdAt!
            }
        }
    }
    func getKey()->String{
        return self.MatchName + self.Team1.description + self.Team2.description
    }
    
    func update(){
        self.RecordedScore = getTeamScore()
        //self.didWin = "Y"
        self.self.TeamsTaskInfo[0].update()
        self.self.TeamsTaskInfo[1].update()
    }
    
    func getTeamScore() ->Int{
        var totalTeamScore = 0
        var ftcScoreingData = FtcScoringData()
        
        for (task,score) in ftcScoreingData.getScoringData(){
            var team1EnteredValue = self.self.TeamsTaskInfo[0].getUserEnteredValueForItem(task)
            var team2EnteredValue = self.self.TeamsTaskInfo[1].getUserEnteredValueForItem(task)
            var teamScore = 0
            // find out the maximum of 2 teams for given task
            if FtcScoringData.isTaskCanbeDoneByTwoTeams( task ){
                teamScore = team1EnteredValue + team2EnteredValue
                
            }else{
                teamScore = team1EnteredValue > team2EnteredValue ? team1EnteredValue: team2EnteredValue
            }
            var allianceTaskScore = teamScore * ftcScoreingData.getScoreValue(task)
            if let maxAllianceScoreForTask = ftcScoreingData.getMaxScoreForAllianceForTask( task ){
                if allianceTaskScore > maxAllianceScoreForTask{
                    allianceTaskScore = maxAllianceScoreForTask
                }
            }
            totalTeamScore += allianceTaskScore
        }
    
        return totalTeamScore
    }
    
    func getTeamScoreByCategory(category:String, teamIndex:Int) ->Int{
        var ftcScoreingData = FtcScoringData()
        var total = 0
        for task in ftcScoreingData.getTasksByCategory(category){
             total += self.TeamsTaskInfo[teamIndex].getUserEnteredValueForItem(task) * ftcScoreingData.getScoreValue(task)
        }
        return total
    }
    
    func getTeamScore(teamIndex:Int) ->Int{
        return self.TeamsTaskInfo[teamIndex].getTotalScore()
    }

    func getTeamScoreByCategory(category:String) ->Int{
        var ftcScoreingData = FtcScoringData()
        var total = 0
        for task in ftcScoreingData.getTasksByCategory(category){
            var team1Score = self.TeamsTaskInfo[0].getUserEnteredValueForItem(task)
            var team2Score = self.TeamsTaskInfo[1].getUserEnteredValueForItem(task)
            
            var max = team1Score > team2Score ? team1Score : team2Score
            total += max * ftcScoreingData.getScoreValue(task)
        }
        return total
    }
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        
        var copy = MatchInfo()
        copy.RecordBy = self.RecordBy
        copy.AlianceName = self.AlianceName
        copy.MatchName = self.MatchName
        copy.Team1 = self.Team1
        copy.Team2 = self.Team2
        copy.RecordedScore = self.RecordedScore
        copy.OfficialScore = self.OfficialScore
        copy.Result = self.Result
        copy.Comment  = self.Comment
        copy.TeamsTaskInfo = [ScoutData(),ScoutData()]
        copy.TeamsTaskInfo[0] = self.TeamsTaskInfo[0].copy() as ScoutData
        copy.TeamsTaskInfo[1] = self.TeamsTaskInfo[1].copy() as ScoutData
        copy.objectId = self.objectId
        return copy
    }
}
