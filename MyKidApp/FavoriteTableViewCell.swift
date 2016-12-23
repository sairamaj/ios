//
//  FavoriteTableViewCell.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 11/28/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    var Favorite:HttpItem?
    
    @IBOutlet weak var linkButton: UIButton!
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onLinkButton(sender: AnyObject) {
        var link = self.Favorite!.Link
        var url:NSURL = NSURL(string: link)!
        UIApplication.sharedApplication().openURL(url)
    }
}
