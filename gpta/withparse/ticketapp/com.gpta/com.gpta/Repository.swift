//
//  Repository.swift
//  com.gpta
//
//  Created by Sourabh Jamlapuram on 4/13/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

private let  _instance = Repository()

class Repository : NSObject{
    
    class var Instance: Repository {
        return _instance
    }
    
    var ticketHolders:[TicketHolder]! = []
    
    
    func getTicketHolders() ->[TicketHolder]{
        
        //if( ticketHolders == nil){
       //     ticketHolders = DataRepository.loadTicketHolders()
      //  }
        
        return ticketHolders
    }
    
    func updateTicketHolder( ticketHolder : TicketHolder){
        DataRepository.updateTicketHolder(ticketHolder)
    }
    
    func startLoadingTicketHolders(callback : ( [TicketHolder]) -> Void ) -> Void{
        TicketHolderLoader().loadTicketHolders(callback)
    }
    
    func startPeriodicUpdates() {
        print("timer suppressed for now")
       // var timer = NSTimer()
       // timer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: Selector("startUpdate"), userInfo: nil, repeats: true)
    }
    
    func startUpdate() {
        
        Repository.Instance.startLoadingTicketHolders ( {
            (objects) -> Void in
             NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().updateToTicketHoldersAvailable, object: objects, userInfo:["ticketHolders": objects])
        })
       
    }
}