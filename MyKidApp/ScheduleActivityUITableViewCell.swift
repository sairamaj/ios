//
//  ScheduleActivityUITableViewCell.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/21/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class ScheduleActivityUITableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesButton: UIButton!
    var ActivityInstance:ScheduleActivityInstance?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let instance = self.ActivityInstance{
            var formatter = NSDateFormatter()
            formatter.dateFormat = "E MMM dd      h:mm a"            // todo move formatter to singleton as it is costly creating a formatter.
            
            self.timeLabel.text = formatter.stringFromDate(instance.Date)
            self.notesButton.setTitle(instance.Notes, forState: UIControlState.Normal)
            
            if isNextDay(instance.Date){
                self.backgroundColor = UIColor.redColor()
            }
        }
    }
    
    func isNextDay(date:NSDate)-> Bool{
        var tmw = NSDate() + 1.days
        return date < tmw
    }
}
