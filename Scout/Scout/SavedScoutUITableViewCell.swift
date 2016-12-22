//
//  SavedScoutUITableViewCell.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/2/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class SavedScoutUITableViewCell: UITableViewCell {

    @IBOutlet weak var ScoutNameLabel: UILabel!
    @IBOutlet weak var MatchNumberLabel: UILabel!
    @IBOutlet weak var TeamNumberLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
