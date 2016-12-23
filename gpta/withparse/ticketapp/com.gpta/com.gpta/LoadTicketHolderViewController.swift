//
//  LoadTicketHolderViewController.swift
//  com.gpta
//
//  Created by Sourabh Jamlapuram on 4/14/16.
//  Copyright (c) 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class LoadTicketHolderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onLoad(sender: AnyObject) {
        var ticketHolders:[TicketHolder] = DataRepository.loadTicketHolders()
        ticketHolders.sort { $0.Name.localizedCaseInsensitiveCompare($1.Name) == NSComparisonResult.OrderedAscending}
        
        // reassign the ids
        var idCounter:Int = 1
        
        for ticketHolder in ticketHolders{
            ticketHolder.Id = idCounter
            print("saving ticketholder: \(ticketHolder.Name): \(ticketHolder.Id)\n")
            Repository.Instance.updateTicketHolder(ticketHolder)
            //NSThread.sleepForTimeInterval(0.1)  // introduce artifical sleep as we are missing some records
            idCounter++
        }
    }
}
