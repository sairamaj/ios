//
//  Kid.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 11/28/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

public class Kid: PFObject,PFSubclassing {
    @NSManaged public var Name:String
    
    private var thumbnailImage:UIImage!
    var ThumbnailImage:UIImage!{
        get{
            return self.thumbnailImage
        }
        set(image){
            self.thumbnailImage = image
        }
    }
    
    
    var Categories:[Category] = []
   
    var Activities2: [Activity] = []
    var ActivityIntances:[ActivityInstance] = []
    
    override init(){
        super.init()
    }
    
    
    init(name:String){
        super.init()
        self.Name = name
    }
    
    func getCategories() -> [Category]{
        return self.Categories
    }
    
    func addCategory(category:Category){
        self.Categories.append(category)
    }
    
    
    func addActivity(activity:Activity){
        println("activity: \(activity.Name) parentId: \(activity.ParentId)")
        if( activity.ParentId == nil){
            var found = false
            for rootActivity in self.Activities2{
                if rootActivity.objectId == activity.objectId{
                    found = true
                }
            }
            if( found == false){
                self.Activities2.append(activity)
            }
        }else{
            var found = false
            for rootActivity in self.Activities2{
                println(" root activity id: \(rootActivity.objectId) and activity parent id:\(activity.ParentId)")
                if rootActivity.objectId == activity.ParentId{
                    rootActivity.SubActivities.append( activity)
                    found = true
                    break
                }
            }
            if found == false{
                // this activity parent not found, get from all activities and get it and add to its activity
                if let parentActivity = Instance.getActivityById( activity.ParentId! ){
                    self.Activities2.append(parentActivity)
                    parentActivity.SubActivities.append(activity)
                }
            }
        }
    }

    func addActivityInstance(instance:ActivityInstance ){
        self.ActivityIntances.append(instance)
    }
    
    func removeActivityInstance(instance:ActivityInstance ){
        for (index,activityInstance) in enumerate(self.ActivityIntances){
            if activityInstance.objectId == instance.objectId{
                self.ActivityIntances.removeAtIndex(index)
                break
            }
        }
    }
    
    override public class func load() {
        registerSubclass()
    }
    
    public class func parseClassName() -> String! {
        return "Kid"
    }

}
