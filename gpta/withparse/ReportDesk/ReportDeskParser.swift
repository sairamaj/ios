//
//  ReportDeskParser.swift
//  ReportDesk2015
//
//  Created by Sourabh Jamlapuram on 4/10/15.
//  Copyright (c) 2015 Sourabh Jama2lapuram. All rights reserved.
//

class ReportDeskParser: NSObject {
    
    private let fix = PFUser.hash() // here's the weird trick
    
    class func parse(){
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        
        var url:NSURL!
        
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
          println(paths)
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    println(dirPath)
                    var programsXmlFile = dirPath + "/programs.xml"
                    url = NSURL(fileURLWithPath:programsXmlFile)
                }
            }
        }
        
        let path = NSBundle.mainBundle().pathForResource("ProgramData", ofType: "txt")
        
        var currentProgram:Program!

        if let content = String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil) {
            var array = content.componentsSeparatedByString("\n")
            for (index,element) in enumerate(array){
                var parts = element.componentsSeparatedByString("|")
                if parts[0] == "#program"{
                    currentProgram = Program(name: parts[2], id: parts[1].toInt()!, programTime: parts[4])
                    currentProgram.ChoreographerName = parts[3]
                    currentProgram.ReportTime = parts[5]
                    currentProgram.GreenroomTime = parts[6]
                    currentProgram.Duration = parts[7]
                    Repository.Instance.addProgram(currentProgram!)
                }
                else if let program = currentProgram{
                    var participantName = parts[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if participantName.isEmpty == false{
                      // todo- 2016
                        var p = Participant()
                        p.Name = parts[0]
                        p.Id =  parts[1].toInt()!

                        Repository.Instance.addParticipantToProgram(currentProgram!, participant: p)

                    }
                }
            }
        }
   
    }
}