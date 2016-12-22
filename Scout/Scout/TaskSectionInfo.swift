//
//  TaskSectionInfo.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 2/2/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class TaskSectionInfo: NSObject {
    var Name:String = ""
    var Team1Score:Int = 0
    var Team2Score:Int = 0
    
    init(name:String) {
        self.Name = name
    }
}
