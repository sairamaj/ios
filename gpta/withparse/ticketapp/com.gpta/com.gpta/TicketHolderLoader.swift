//
//  TicketHolderLoader.swift
//  com.gpta
//
//  Created by Sourabh Jamlapuram on 4/13/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

class TicketHolderLoader{
    var ticketHolders:[TicketHolder] = []
    
    func loadFromParse(query:PFQuery, callback : ( [AnyObject]! ) -> Void ){
        query.limit = 300
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

    func loadTicketHolders( callback : ( [TicketHolder]) -> Void ){
        self.ticketHolders.removeAll(keepCapacity: true)
        loadFromParse(TicketHolder.query()!,
            callback: {
                (objects) -> Void in
                for object in objects{
                    self.ticketHolders.append(object as! TicketHolder)
                }
                
                callback( self.ticketHolders )
        })
    }

}