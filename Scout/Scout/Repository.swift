//
//  Repository.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 11/30/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit


private let  _instance = Repository()

class Repository: NSObject {
    
    class var Instance: Repository {
        return _instance
    }
    
    override init(){
        super.init()
        println("init")
    }
    

    var ScoutsData:[ScoutData] = []
    var Scouts:[Scout] = []
    private var Tournaments:[Tournament] = []
    var MatchesData:[MatchInfo] = []
    
    
    func getTournaments() ->[Tournament]{
        return self.Tournaments
    }
    
    func getScouts() -> [Scout]{
        return self.Scouts
    }

    
    func saveMatch( tournament:Tournament ,  matchInfo: MatchInfo ){
        
        self.saveInParse(matchInfo.TeamsTaskInfo[0], callback: { (objectId1) -> Void in
            self.saveInParse(matchInfo.TeamsTaskInfo[1], callback: { (objectId2) -> Void in
                println("team1 id: \(objectId1) and team2 id \(objectId2)" )
                
                
                var team1Relationship = matchInfo.relationForKey("team1taskinfo")
                var team2Relationship = matchInfo.relationForKey("team2taskinfo")
                
                team1Relationship.addObject(matchInfo.TeamsTaskInfo[0])
                team2Relationship.addObject(matchInfo.TeamsTaskInfo[1])
                
                self.saveInParse(matchInfo, callback :{ (matchObjectId) -> Void in
                    
                    println("match  id: \(matchObjectId)")
                    matchInfo.objectId = matchObjectId
                    
                    // save matches in tournament
                    var tournamentMatchRelationship = tournament.relationForKey("matches")
                    tournamentMatchRelationship.addObject(matchInfo)
                    self.saveInParse(tournament, callback : { (objectId) -> Void in
                            // saved the match in tournament.
                    } )
                    
                    // save scout in match.
                    var recordedByRelationship = matchInfo.relationForKey("recordedby")
                    recordedByRelationship.addObject(matchInfo.RecordBy)
                    self.saveInParse(matchInfo, callback: { (objectId) -> Void in
                        // saved the scout in match.
                    })
                    
                })
                
     
            })
        })
    }
    

    func deleteMatch( matchData : MatchInfo){
        // remove from array
        for (index,item) in enumerate(self.MatchesData){
            if matchData.getKey() == item.getKey(){
                self.MatchesData.removeAtIndex(index)
                break
            }
        }
        
        // remove from storages
        //  pfScoutData.objectId = scoutData.pfObjectId
        matchData.deleteInBackgroundWithBlock { (success, error) -> Void in
            if success{
                println("success in deleting: \(matchData.objectId)")
            }else{
                println("Error \(error) in deleting: \(matchData.objectId)")
            }
        }

    }

    func loadMatches(tournament:Tournament){
        var matchesRelationship =  tournament.relationForKey("matches")
        
        self.loadFromParse(matchesRelationship.query(),
            callback: { (objects) -> Void in
            var tournamentMatches:[MatchInfo] = []
            for object in objects{
                tournamentMatches.append(object as MatchInfo)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().successfullyLoadedTournamentMatches, object: tournamentMatches)
            
            for match in tournamentMatches{
                self.loadMatchRelations(match)
            }
            } ,
            callbackForError : { (error) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().successfullyLoadedTournamentMatches, object: [MatchInfo]() )
        })
    }
    
    func loadMatchRelations(match:MatchInfo){
        
        // recorded by
        var recordedByRelationship = match.relationForKey("recordedby")
        self.loadFromParse(recordedByRelationship.query(), callback: { (objects) -> Void in
            for object in objects{
                println("relationship object: \(object)")
                match.RecordBy = object as Scout
            }
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().successfullyLoadedMatchRecordBy, object: match)
        })

        
        var team1Relationship = match.relationForKey("team1taskinfo")
        self.loadFromParse(team1Relationship.query(), callback: { (objects) -> Void in
            for object in objects{
                println("relationship object: \(object)")
                match.TeamsTaskInfo[0] = object as ScoutData
                match.TeamsTaskInfo[0].load()
            }
        })
        
        // Load asynchronously Team2 scout data.
        var team2Relationship = match.relationForKey("team2taskinfo")
        self.loadFromParse(team2Relationship.query(), callback: { (objects) -> Void in
            for object in objects{
                println("relationship object: \(object)")
                match.TeamsTaskInfo[1] = object as ScoutData
                match.TeamsTaskInfo[1].load()
            }
        })

    }
    
    func loadMatches(){
       
        self.loadFromParse( MatchInfo.query(), callback :{ ( objects ) -> Void in
           println("loaded successfully")
             for object in objects{
                var matchInfo = object as MatchInfo
                self.MatchesData.append(matchInfo)
                // Load asynchronously Team1 scout data.
                var team1Relationship = matchInfo.relationForKey("team1taskinfo")
                self.loadFromParse(team1Relationship.query(), callback: { (objects) -> Void in
                    for object in objects{
                        println("relationship object: \(object)")
                        matchInfo.TeamsTaskInfo[0] = object as ScoutData
                        matchInfo.TeamsTaskInfo[0].load()
                    }
                })
                
                // Load asynchronously Team2 scout data.
                var team2Relationship = matchInfo.relationForKey("team2taskinfo")
                self.loadFromParse(team2Relationship.query(), callback: { (objects) -> Void in
                    for object in objects{
                        println("relationship object: \(object)")
                        matchInfo.TeamsTaskInfo[1] = object as ScoutData
                        matchInfo.TeamsTaskInfo[1].load()
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().dataLoadedSuccessfully, object: self.MatchesData)
                })
            }
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().dataLoadedSuccessfully, object: self.MatchesData)
        } )
    }
    
    func loadTournaments(){
        self.loadFromParse(Tournament.query(), callback: { (objects) -> Void in
            for object in objects{
                self.Tournaments.append( object as Tournament)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().successfullyLoadedTournaments, object: self.Tournaments)
        })
    }
    
    func loadScouts(){
        self.loadFromParse(Scout.query(), callback: { (objects) -> Void in
            for object in objects{
                self.Scouts.append( object as Scout)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().successfullyLoadedScouts, object: self.Tournaments)
        })
    }
    
    
    func saveScout(scout:Scout){
       self.saveInParse(scout, callback: { (objectId) -> Void in
           scout.objectId = objectId
           self.Scouts.append(scout)
       })
    }
    
    func saveTournament(tournament:Tournament){
        self.saveInParse(tournament, callback: { (objectId) -> Void in
            tournament.objectId = objectId
            self.Tournaments.append(tournament)
        })
    }
    
    
    func saveInParse(object:PFObject, callback :(String!)->Void ){
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success{
                println("Successfully saved pfScoutData: \(object.objectId)" )
                callback(object.objectId)
                //  scout.pfObjectId = pfScoutData.objectId // update the pf object id.
            }else{
                println("Error in saving: \(error)")
            }
        }
    }
    
    func loadFromParse(query:PFQuery, callback : ( [AnyObject]! ) -> Void ){
        self.loadFromParse( query, callback, { (error:NSError!)->Void in } )
    }
    
    func loadFromParse(query:PFQuery, callback : ( [AnyObject]! ) -> Void , callbackForError : ( NSError! ) -> Void){
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if( error != nil){
                println("error loading \(error)")
                callbackForError(error)
            }else{
                callback(objects)
            }
        }
    }
    
    func saveToUserDefaults(dict:[String:String])->Void{
        var defaults = NSUserDefaults.standardUserDefaults()
        for (key,val) in dict{
            defaults.setObject(val, forKey: key)
        }
    }
    
    func loadFromUserDefaults(keys:[String])->[String:String]{
        var dict =  [String:String]()
        
        var defaults = NSUserDefaults.standardUserDefaults()
        for key in keys{
            if let val: AnyObject = defaults.objectForKey(key){
                dict[key] = val.description
            }
        }
        return dict
    }
    
}
