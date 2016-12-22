//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit


protocol SidePanelViewControllerDelegate {
    func menuItemSelected(menuName:String)
}


class SidePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    var menuItems = ["Home", "About", "FaceBook", "Web", "Twitter","Rate this App"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //  self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.separatorColor = UIColor.lightGrayColor()
        
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
        var imageView = UIImageView(image: UIImage(named: "leftMenu.jpg"))
        self.tableView.backgroundView = imageView
    
        
        self.view.layer.borderWidth = 0.6
        self.view.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menucellidentifier", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = menuItems[ indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    // Mark: Table View Delegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRect(x: 0,y: 0,width: self.tableView.frame.size.width,height: 20) )
        view.backgroundColor = UIColor.clearColor()
          return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menuItemSelected(self.menuItems[indexPath.row])
    }
    
}

