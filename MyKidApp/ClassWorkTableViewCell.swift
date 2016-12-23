//
//  ClassWorkTableViewCell.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/15/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ClassWorkTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesButton: UIButton!
    var ActivityInstance:ClassWorkActivityInstance?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        if let instance = self.ActivityInstance{
            var formatter = NSDateFormatter()
            formatter.dateFormat = "E MMM dd      h:mm a"            // todo move formatter to singleton as it is costly creating a formatter.
            
            self.dateLabel.text = formatter.stringFromDate(instance.Date)
            self.notesButton.setTitle(instance.Notes, forState: UIControlState.Normal)
            
        }

    }

}
