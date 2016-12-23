//
//  Repository.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/10/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit
import Parse

private let  _instance = Repository()

class Repository: NSObject {
    
    class var Instance: Repository {
        return _instance
    }
    var isNetworkAvailable:Bool!
    
    func setNetWork(network:Bool){
        self.isNetworkAvailable = network
    }

    var programs:[Program] = []
    var participants:[Participant] = []
    
    func getPrograms() ->[Program]{
        return programs
    }
    
    func getParticipants() ->[Participant]{
            return self.participants
    }
    
    func addProgram(program:Program){
        self.programs.append(program)
    }
    
    func addParticipantToProgram(program:Program, participant : Participant){
        self.participants.append(participant)
        program.addParticipant(participant)
    }
    
    func getProgramForParticipant(participant:Participant) ->String{
        for program in self.programs{
            for p in program.Participants{
                if p.Name == participant.Name{
                    return program.Name
                }
            }
        }
        return "na"
    }
    
    func updateParticipant(p:Participant){
        if( self.isNetworkAvailable! ){
        saveInParse(p, callback: { (String) -> Void in
            print("saved")
        })}else{
            p.saveEventually()
        }
    }
    
    func updateLocalParticipant(participantFromStorage: Participant,isLocalSource:Bool){
        var participant = self.participants.first { (p,index) -> Bool in
            return p.Id == participantFromStorage.Id
        }
        if let p1 = participant{
            
            if( p1.updatedAt == nil || participantFromStorage.updatedAt! > p1.updatedAt!){
                p1.IsArrived = participantFromStorage.IsArrived
                if( isLocalSource == false){
                    p1.objectId = participantFromStorage.objectId
                }
            }
        }
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

    func loadParticipants(){
     // todo 2016
      
        if( self.isNetworkAvailable! == false){
            Participant.query()!.fromLocalDatastore().findObjects()!.forEach { (element) -> Void in
                self.updateLocalParticipant((element as! Participant) as Participant, isLocalSource:true)
            }
            return
        }
        
        self.loadFromParse(Participant.query()!,
            callback: { (objects) -> Void in
                for object in objects{
                    self.updateLocalParticipant(object as! Participant, isLocalSource:false)
                }
                NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().successfullyLoadedParticipants, object: self.participants)
            })

    }
    
    func loadParticipantswithCallback(callback : ( [Participant]) -> Void){
        // todo 2016
        
        if( self.isNetworkAvailable! == false){
            Participant.query()!.fromLocalDatastore().findObjects()!.forEach { (element) -> Void in
                self.updateLocalParticipant((element as! Participant) as Participant, isLocalSource:true)
            }
            return
        }
        
        self.loadFromParse(Participant.query()!,
            callback: { (objects) -> Void in
                for object in objects{
                    self.updateLocalParticipant(object as! Participant, isLocalSource:false)
                }
                NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().successfullyLoadedParticipants, object: self.participants)
        })
        
    }

    
    func loadFromParse(query:PFQuery, callback : ( [AnyObject]! ) -> Void ){
       // todo: 2016
        //self.loadFromParse( query, callback, { (error:NSError!)->Void in } )
        self.loadFromParse( query, callback: callback, callbackForError: { (error:NSError!)->Void in } )
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


}
