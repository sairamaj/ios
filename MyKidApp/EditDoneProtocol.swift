//
//  EditDoneProtocol.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/12/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

protocol EditDoneProtocol{
    func onEditDone(controller: UIViewController, object: AnyObject! , isNew:Bool)
}