//
//  AllianceUIButton.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 2/1/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class AllianceUIButton: UIButton {
    
    override init(){
        self.name = ""
        super.init()
        self.Name = "blue"
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = ""
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 18;
        self.Name = "blue"
    }
    
    private var name:String
    
    var Name:String{
        get{
            return self.name
        }
        set(value){
            self.name = value
            self.backgroundColor = value == "blue" ? UIColor.blueColor() : UIColor.redColor()
        }
    }
    
    func ToggleName(){
        self.Name = self.Name == "blue" ? "red" : "blue"
    }
    
}

