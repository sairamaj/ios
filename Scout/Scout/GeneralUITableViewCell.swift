//
//  GeneralUITableViewCell.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/4/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class GeneralUITableViewCell: BaseUITableViewCell , UITextViewDelegate{

    @IBOutlet weak var CommentBox: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.CommentBox.delegate = self
    }
     override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.CommentBox.text = self.CurrentMatchData.Comment

        self.CommentBox.layer.borderColor = UIColor.grayColor().CGColor
        self.CommentBox.layer.borderWidth = 1.0
        self.CommentBox.layer.cornerRadius = 8
    }

    
    func textViewDidChange(textView: UITextView){
        self.CurrentMatchData.Comment = textView.text
    }
}
