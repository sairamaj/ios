//
//  AppRepository.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 11/27/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

var Instance:AppRepository = AppRepository()

class AppRepository: NSObject , RepositoryProtocol{
   
    var Activities:[Activity] = []
    var Kids:[Kid] = []

    func loadActivityInstances(kid:Kid, query:PFQuery){
        
        query.whereKey("KidId", equalTo: kid.objectId)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if( error != nil){
                println(error)
            }else{
                for object in objects{
                    kid.addActivityInstance( object as ActivityInstance)
                }
            }
        }
    }
    
    func getActivityById( objectId :String) -> Activity!{
        for activity in self.Activities{
            if activity.objectId == objectId{
                return activity
            }
        }
        return nil
    }

    class func loadData(){
        var pfQuery = Activity.query()
        pfQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if( error != nil){
                println(error)
            }else{
                for obj in objects{
                    Instance.Activities.append(obj as Activity)
                }
                
                for activity in Instance.Activities{
                    if activity.ParentId != nil{
                       var parentActivity = Instance.Activities.first({ (sub, ret) -> Bool in
                         return sub.objectId == activity.ParentId
                       })
                        if parentActivity != nil{
                            parentActivity?.addSubActivity(activity)
                        }
                    }
                }
                Instance.loadKids()
            }
        }
    }
    
    func loadKids(){
        
        var rootActivities = self.Activities.filter({ (activity) -> Bool in
            return activity.ParentId == nil
        })
        

        
        self.loadFromParse(Kid.query(), callback: { (objects) -> Void in
            for obj in objects{
                var kid = obj as Kid
                Instance.Kids.append(kid)
                
                var imageData = kid["image"]
                println(" image data is : \(imageData)" )
                if let pfData = imageData as? PFFile{
                    println(" data" )
                    var d = pfData.getData()
                    println(" d is :\(d)")
                    kid.ThumbnailImage = UIImage(data: pfData.getData() )
                }
                
                var kidAssignedActivitiesRelation = kid.relationForKey("assignedActivities")

                // load activities
                self.loadFromParse(kidAssignedActivitiesRelation.query(), callback: { (objects) -> Void in
                    // first add all parent ids
                    for object in objects{
                        var assignedActivity = object as Activity
                        if assignedActivity.ParentId == nil{
                            kid.addActivity( assignedActivity)
                        }
                    }
                    
                    for object in objects{
                        var assignedActivity = object as Activity
                        if assignedActivity.ParentId != nil{
                            kid.addActivity( assignedActivity)
                        }
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().dataLoadedSuccessfully, object: self)
                })
                
              //  for activity in rootActivities{
             //       kid.addActivity(activity)
             //   }
                
               /* for activity in self.Activities{
                    //kid.addActivity(activity)
                    println("activity name is: \(activity.Name)" )
                    if activity.Name == "Test" && kid.Name == "Sourabh"{
                        println("assigning \(activity.Name) to \(kid.Name)")
                            self.assignActivityToKid(kid, activity:activity)
                        }
                }*/
                
                Instance.loadActivityInstances( obj as Kid , query: ScheduleActivityInstance.query())
                Instance.loadActivityInstances( obj as Kid , query: LinkActivityInstance.query())
                Instance.loadActivityInstances( obj as Kid , query: HomeClassActivityInstance.query())
                Instance.loadActivityInstances( obj as Kid , query: VocabularyActivityInstance.query())
                Instance.loadActivityInstances( obj as Kid , query: ClassWorkActivityInstance.query())
            
            }
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys().dataLoadedSuccessfully, object: self)
        })
    }
    
    func assignActivityToKid( kid:Kid, activity:Activity){
        var assignedActivityRelation = kid.relationForKey("assignedActivities")
        
        assignedActivityRelation.addObject(activity)
        self.saveInParse(kid, callback :{ (kidId) -> Void in
            
            println("kid  id: \(kidId)")
        })
    }
    
    func saveActivityInstance(instance: ActivityInstance){
        saveInParse(instance, callback: { (objectId) -> Void in
            instance.objectId = objectId
        })
    }
    
    func addActivityInstance(kid:Kid, instance: ActivityInstance){
        //instance.saveInBackground()
     //   saveInParse(instance, callback: { (objectId) -> Void in
     //       instance.objectId = objectId
     //   })
        kid.addActivityInstance(instance)
    }
    
    func removeActivityInstance(kid:Kid, instance: ActivityInstance){
        instance.deleteInBackground()
        kid.removeActivityInstance(instance)
    }
    
    func addKid(kid:Kid){
        self.Kids.append(kid)
    }
    
    func removeKid(kid:Kid){
        for (index,aKid) in enumerate( Instance.Kids ){
            if kid.objectId == aKid.objectId{
                Instance.Kids.removeAtIndex(index)
                self.deleteInParse(kid, callback:{ (id)->Void in } )
                break
            }
        }
    }
    
    func saveKid(kid:Kid){
        
        let imageData = UIImagePNGRepresentation(kid.ThumbnailImage)
        if imageData != nil{
            let imageFile: PFFile = PFFile(data: imageData)
             kid["image"] = imageFile
        }
       
        self.saveInParse(kid, callback :{ (kidId) -> Void in

            println("kid  id: \(kidId)")
            /*if let image = kid.ThumbnailImage {
                let imageData = UIImagePNGRepresentation(kid.ThumbnailImage)
                let imageFile: PFFile = PFFile(data: imageData)
            
                var photo = PFObject(className: "kidPhotos")
                photo["image"] = imageFile
                self.saveInParse( photo, callback : { (id) -> Void in
                    println("photo  id: \(id)")
                })
            }*/
        })

    }
    
    func saveInParse(object:PFObject, callback :(String!)->Void ){
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success{
                println("Successfully saved: \(object.objectId)" )
                callback(object.objectId)
                //  scout.pfObjectId = pfScoutData.objectId // update the pf object id.
            }else{
                println("Error in saving: \(error)")
            }
        }
    }
    
    func deleteInParse(object:PFObject, callback :(String!)->Void ){
        object.deleteInBackgroundWithBlock{ (success, error) -> Void in
            if success{
                println("deleted saved: \(object.objectId)" )
                callback(object.objectId)
                //  scout.pfObjectId = pfScoutData.objectId // update the pf object id.
            }else{
                println("Error in deleted: \(error)")
            }
        }
    }

    func loadFromParse(query:PFQuery, callback : ( [AnyObject]! ) -> Void ){
        
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if( error != nil){
                println("error loading \(error)")
            }else{
                callback(objects)
            }
        }
    }

}
