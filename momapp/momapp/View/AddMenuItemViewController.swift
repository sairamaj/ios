//
//  AddMenuItemViewController.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 12/13/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import UIKit
import SwiftForms

protocol MenuItemAddedDelegate{
    func MenuItemAdded(menuItem:String)
}

class AddMenuItemViewController: FormViewController {

    var delegate:MenuItemAddedDelegate? = nil
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let dialogheigth:CGFloat = self.view.frame.height * 0.5;
        let dialogwidth:CGFloat = self.view.frame.width * 0.5;
        self.preferredContentSize = CGSize(width: dialogwidth, height: dialogheigth)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
 */

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    fileprivate func loadForm() {
        let form = FormDescriptor(title: "Add Menu Item")
        
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let row = FormRowDescriptor(tag: Static.nameTag, type: .email, title: "Menu Item")
        row.configuration.cell.appearance = ["textField.placeholder" : "burrito" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section1.rows.append(row)
        
        form.sections = [section1]
        
        self.form = form
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSave(_ sender: Any) {
        let menuItem = self.form.formValues()["name"]
        
      //  let alertController = UIAlertController(title: "Form output", message: menuItem as! String?, preferredStyle: .alert)
        
      //  let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
      //  }
        
       // alertController.addAction(cancel)
        
      //  self.present(alertController, animated: true, completion: nil)
        Repository().saveMenuItem(menuitem: menuItem as! String)
        navigationController?.popViewController(animated: true)
        if let callback = self.delegate{
            callback.MenuItemAdded(menuItem: menuItem as! String)
        }
    }

    func showAnimate()
    {
  
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    }
