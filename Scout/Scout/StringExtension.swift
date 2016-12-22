//
//  StringExtension.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 1/3/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

extension String {
    
   /*func toDate(let format:String = "dd/MM/yyyy") -> NSDate? {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone()
        formatter.dateFormat = format
        
        return formatter.dateFromString(self)
    }*/
    
    func trimWhiteSpaces() -> String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}