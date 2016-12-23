//
//  DataRepository.swift
//  com.gpta
//
//  Created by Sourabh Jamlapuram on 4/13/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

class DataRepository{
    class func loadTicketHolders() ->[TicketHolder]{

    
        
        let path = NSBundle.mainBundle().pathForResource("TicketHolderData", ofType: "txt")
        
        var ticketHolders:[TicketHolder] = []
        var idCounter:Int = 1
        
        if let content = String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil) {
            var array = content.componentsSeparatedByString("\n")
            for (index,element) in enumerate(array){
                if( element.trimWhiteSpaces().length > 0 ){
                    var parts = element.componentsSeparatedByString("|")
                    //var ticketHolder = TicketHolder(name: parts[0], confirmationNumber: parts[1], adultCount: parts[2].toInt()!, kidCount: parts[3].toInt()!)
                    print("element: \(element) \n")
                    var ticketHolder = TicketHolder(id:idCounter, name: parts[0], confirmationNumber: parts[1], adultCount: parts[2].toInt()!, kidCount: parts[3].toInt()!)
                    ticketHolders.append(ticketHolder)
                    idCounter++
                }
            }
        }
        return ticketHolders
    }
    
    class func updateTicketHolder(ticketHolder: TicketHolder){
        if(isNetworkAvailable() ){
            saveInParse(ticketHolder, callback: { (String) -> Void in
                print("saved in parse :\(ticketHolder.Name)\n")
            })}else{
            ticketHolder.saveEventually()
        }
    }
    
    class func saveInParse(object:PFObject, callback :(String!)->Void ){
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
    
    class func isNetworkAvailable() -> Bool{
        return true
    }
    
   
}