//
//  VocabularyActivityInstance.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/7/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class VocabularyActivityInstance: KidActivityInstance {
    

    @NSManaged public var Word:String
    @NSManaged public var Meaning:String


    
    override init(){
        super.init()
        self.Type = "vocabulary"
    }
    
    override public class func load() {
        registerSubclass()
    }
    
    public override class func parseClassName() -> String! {
        return "VocabularyActivityInstance"
    }

}
