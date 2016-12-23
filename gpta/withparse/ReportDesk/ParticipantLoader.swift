//
//  ParticipantLoader.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/15/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

class ParticipantLoader{
    
    var participants:[Participant] = []
    
    func loadParticipantswithCallback(callback : ( [Participant]) -> Void){
        self.participants.removeAll(keepCapacity: true)
                self.loadFromParse(Participant.query()!,
            callback: { (objects) -> Void in
                for object in objects{
                    self.participants.append(object as! Participant)
                }
                
                callback(self.participants)
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