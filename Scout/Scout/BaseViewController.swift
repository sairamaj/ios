//
//  BaseViewController.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 2/10/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController ,  ContentPanelProtocol{

    var internalDelegate:CenterViewControllerDelegate?
    var delegate: CenterViewControllerDelegate? {
        get {
            return internalDelegate
        }
        set(value){
            self.internalDelegate = value
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onMenu(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
