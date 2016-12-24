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

/*
 Adds menu item.
 Swift forms were used here: https://github.com/ortuman/SwiftForms.git
 
 */
class AddMenuItemViewController: FormViewController {
    
    var delegate:MenuItemAddedDelegate? = nil
    var curentMenuItems:[String] = []
    
    struct Static {
        static let nameTag = "name"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
     Saves menu item.
     */
    @IBAction func onSave(_ sender: Any) {
        
        
        if self.form.formValues()["name"] == nil {
            showError(message: "Cannot be empty")
            return
        }
        
        let menuItem = self.form.formValues()["name"]
        
        if menuItem is String{
            if IsExists(menuItem: menuItem as! String){
                showError(message: menuItem as! String + "Already exists.")
                return
            }
            //  self.present(alertController, animated: true, completion: nil)
            Repository.shared.saveMenuItem(menuitem: menuItem as! String)
            navigationController?.popViewController(animated: true)
            if let callback = self.delegate{
                callback.MenuItemAdded(menuItem: menuItem as! String)
            }
        }else{
            showError(message: "Cannot be empty")
            return
        }
        
    }
    
    /*
     shows Error.
     */
    func showError(message:String) -> Void{
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
    
    /*
     Chekcs whether item already exists or not
     */
    func IsExists(menuItem:String) -> Bool{
        for item in self.curentMenuItems{
            if( item.lowercased() == menuItem.lowercased()){
                return true
            }
        }
        
        return false
    }
    
}
