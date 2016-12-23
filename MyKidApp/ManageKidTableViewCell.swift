//
//  ManageKidTableViewCell.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/12/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ManageKidTableViewCell: UITableViewCell {

    @IBOutlet weak var kidImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    var CurrentKid:Kid!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if self.CurrentKid == nil{
            return
        }
        
        self.nameLabel.text = self.CurrentKid.Name
        self.kidImageView.image = self.CurrentKid.ThumbnailImage
        // Configure the view for the selected state
    }

}
