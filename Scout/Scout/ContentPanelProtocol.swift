//
//  ContentPanelProtocol.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 2/21/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

@objc protocol ContentPanelProtocol {
    var delegate: CenterViewControllerDelegate? {get set}
    func onMenu(sender: AnyObject)
}
