//
//  AdminViewController.swift
//  Scout
//
//  Created by Sourabh Jamlapuram on 12/1/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit
import MessageUI

class AdminViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var emailIdText: UITextField!
    
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
    
    @IBAction func onSend(sender: AnyObject) {
       // var csv = Repository.Instance.getDataAsCsv()
        var csv = "not available"
        //showMessage(csv, title: "info")
        // return
        var fileName = saveToFile(csv)!
        sendMail(fileName,to: self.emailIdText.text )

    }
    
    func sendMail(fileName:String, to:String){
        var emailTitle = "Scout App"
        var messageBody = "SouctApp Information"
        var toRecipents = [to]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody("scout data as attachment.", isHTML: false)
        var fileData: NSData = NSData(contentsOfFile: fileName)!
        mc.addAttachmentData(fileData, mimeType: ".txt", fileName: fileName)
        
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func saveToFile(data:String)-> String!{
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = dirs[0].stringByAppendingPathComponent( "scoutdata.txt")
            data.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            return path
        }
        return nil
    }


}
