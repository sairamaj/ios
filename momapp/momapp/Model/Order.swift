//
//  Order.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 12/12/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

class Order{
    var MenuItem:String!
    var Date:Date!
    var ConfirmationId:String!
    
    init(menuItem:String , date:Date , confirmationId:String){
        self.MenuItem = menuItem
        self.Date = date
        self.ConfirmationId = confirmationId
    }
}
