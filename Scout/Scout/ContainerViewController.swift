//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController , CenterViewControllerDelegate, SidePanelViewControllerDelegate{
    
    var centerNavigationController: UINavigationController!
    var homeViewController: UIViewController!
    var aboutViewController: UIViewController!
    let afoofaFacebookUrl = "https://www.facebook.com/AFOOFA5939"
    let afoofaWeb = "http://www.teamafoofa.org/"
    let afoofaTwitter = "https://twitter.com/afoofa5939"
    let rateThisAppUrl = "itms-apps://itunes.apple.com/app/putScoutAppIdHere"
    
    
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftViewController: SidePanelViewController?
    let centerPanelExpandedOffset: CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewController = UIStoryboard.homeViewController()
        var contentPanelDelegate = (homeViewController! as ContentPanelProtocol)
        contentPanelDelegate.delegate = self
       
        aboutViewController = UIStoryboard.aboutViewController()
        contentPanelDelegate = (aboutViewController! as ContentPanelProtocol)
        contentPanelDelegate.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: homeViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
        
    }
    
    // MARK: CenterViewController delegate methods
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .RightPanelExpanded:
            toggleRightPanel()
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            //leftViewController!.animals = Animal.allCats()
            leftViewController?.delegate = self
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func addRightPanelViewController() {
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    
    func animateRightPanel(#shouldExpand: Bool) {
    }
    
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
    }
    
    func menuItemSelected(menuName:String){
        self.collapseSidePanels()
        var centerController:UIViewController!
        switch( menuName.lowercaseString){
            case "about":
                centerController = self.aboutViewController
                break
            case "home":
                 centerController = self.homeViewController
                break
            case "facebook":
                var url:NSURL = NSURL(string: afoofaFacebookUrl)!
                UIApplication.sharedApplication().openURL(url)
                return
            case "web":
                var url:NSURL = NSURL(string: afoofaWeb)!
                UIApplication.sharedApplication().openURL(url)
                return
            case "twitter":
                var url:NSURL = NSURL(string: afoofaTwitter)!
                UIApplication.sharedApplication().openURL(url)
                return
            case "rate this app":
                // itms-apps://itunes.apple.com/app/idAPP_ID
                var rateAppUrl:NSURL = NSURL(string: rateThisAppUrl)!
                UIApplication.sharedApplication().openURL(rateAppUrl)
                return
        default:
            break
        }
        
        if let centerViewController = centerController{
            self.centerNavigationController.setViewControllers([centerViewController], animated: true)
        }
 
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
    
    class func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
    }
    
    class func homeViewController() -> UIViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? UIViewController
    }
    class func aboutViewController() -> UIViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("abouttableviewidentifier") as? UIViewController
    }
}