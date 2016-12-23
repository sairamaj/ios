//
//  RepsitoryFactory.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 11/28/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class RepsitoryFactory: NSObject {
    class func get() -> RepositoryProtocol{
        return AppRepository()
    }
}
