//
//  EditActivityProtocol.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/7/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

protocol EditActivityInstanceDoneDelegate{
    func ActivityDone(controller: UIViewController, activityInstance: ActivityInstance , isNew:Bool)
}