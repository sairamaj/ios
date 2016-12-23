//
//  Program.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/10/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class Program: NSObject {
    internal var  Name:String!
    internal var Id:Int
    internal var ProgramTime:String!
    internal var ReportTime:String!
    internal var GreenroomTime:String!
    internal var Duration:String!
    internal var Participants:[Participant] = []
    internal var ChoreographerName:String!
    
    
    init(name:String, id:Int, programTime:String){
        self.Name = name
        self.Id = id
        self.ProgramTime = programTime      // todo: need to change the time
    }
    
    func getParticipants()->[Participant]{
        return self.Participants
    }
    
    func addParticipant(participant:Participant){
        self.Participants.append(participant)
    }
    
    func areAllParticipantsArrived()->Bool{
        var ret = self.Participants.any { (p) -> Bool in
            p.IsArrived == 0
        }
        println("program \(self.Name) staus:\(!ret)")
        return !ret
    }
    
    func getTotalParticipants()->Int{
        return self.Participants.count
    }
    
    func getArrivedCount()->Int{
        var currentArrived = 0;
        self.Participants.forEach { (element) -> Void in
            if( element.IsArrived > 0){
                currentArrived++;
            }
        }
        return currentArrived
    }
    

}
