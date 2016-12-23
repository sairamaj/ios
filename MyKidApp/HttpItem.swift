//
//  HttpItem.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 11/28/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class HttpItem: NSObject {
    var Link:String
    var Text:String
    
    init(text:String, link:String){
        self.Text = text
        self.Link = link
        
        super.init()
    }
}
