//
//  TicketHolder.swift
//  com.gpta
//
//  Created by Sourabh Jamlapuram on 4/13/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation
import Parse

class TicketHolder : PFObject, PFSubclassing{
    @NSManaged var  Name:String!
    @NSManaged var ConfirmationNumber:String!
    @NSManaged var AdultCount:Int
    @NSManaged var KidCount:Int
    @NSManaged var AdultsArrived:Int
    @NSManaged var KidsArrived:Int
    @NSManaged var Id:Int
    
    init(id:Int, name:String , confirmationNumber:String, adultCount:Int, kidCount:Int){
        super.init()
        
        self.Name = name
        self.ConfirmationNumber = confirmationNumber
        self.AdultCount = adultCount
        self.KidCount = kidCount
        self.AdultsArrived = 0
        self.KidsArrived = 0
        self.Id = id
    }
    
    override init(){
            super.init()
    }
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "TicketHolder"
    }
    
    func getArrivalStatus() -> TicketHolderArrivalStatus{
        var totalArrived = self.KidsArrived + self.AdultsArrived
        var totalCount = self.KidCount + self.AdultCount
        
        if( totalArrived == 0){
            return TicketHolderArrivalStatus.NoneArrived
        }else if( totalArrived < totalCount){
            return TicketHolderArrivalStatus.PartialArrived
        }
        
        return TicketHolderArrivalStatus.AllArrived
    }
    
    func markAllArrived() -> Void{
        self.AdultsArrived = self.AdultCount
        self.KidsArrived = self.KidCount
    }
    
    func getTotalArrived() ->Int{
        return self.AdultsArrived + self.KidsArrived
    }
    
    func getTotalTickets() ->Int{
        return self.AdultCount + self.KidCount
    }
}