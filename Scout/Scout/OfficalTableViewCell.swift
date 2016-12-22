//
//  OfficalTableViewCell.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 1/1/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class OfficalTableViewCell: BaseUITableViewCell, UIPickerViewDataSource ,UIPickerViewDelegate{

    @IBOutlet weak var resultPicker: UIPickerView!
    @IBOutlet weak var scoreTextField: UITextField!
    let ResultsInfo = ["NA","Won","Lost"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.resultPicker.dataSource = self
        self.resultPicker.delegate = self
        
        if let result = self.CurrentMatchData.Result{
            for (index,resultInfo) in enumerate(self.ResultsInfo){
                if resultInfo == result{
                    self.resultPicker.selectRow ( index, inComponent: 0 , animated: false)
                }
            }
        }
        
        if self.CurrentMatchData.OfficialScore > 0{
            self.scoreTextField.text = self.CurrentMatchData.OfficialScore.description
        }
    }

    @IBAction func ScoreTextFieldEditchanged(sender: AnyObject) {
        if let score = self.scoreTextField.text.toInt(){
            self.CurrentMatchData.OfficialScore = score
        }else{
            self.CurrentMatchData.OfficialScore = 0
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ResultsInfo.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.ResultsInfo[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.CurrentMatchData.Result = self.ResultsInfo[row]
    }

}
