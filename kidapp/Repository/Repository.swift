//
//  Repository.swift
//  kidapp
//
//  Created by Sourabh Jamlapuram on 12/19/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

/*
 class communicates to aws REST api for mom restaurant items 
 */
class Repository{
    
    /*
     Singleton instance.
     */
    public static let shared:Repository = {
        let instance = Repository()
        return instance
    }()
    
    /*
     Cannot create instance. (singleton pattern)
     */
    private init(){
        
    }
    
    /*
     gets menuitems and callback will be called with menu items.
     */
    func getMenuItems(callback : @escaping ( [String]) -> Void){
        
        
        get( url: URL(string: getApiUrl(resource: "menuitems"))!, callback: {
            (json) -> Void in
            
            //Implement your logic
            print(json)
            var items = [String]()
            
            for m in json{
                if let dictionary = m as? [String: Any] {
                    items.append( dictionary["name"] as! String)
                }
            }
            
            callback(items)
            
        })
        
    }
    
    
    /*
     order given menu item.
     */
    func orderMenu(menuitem : String) {
        print("ordering menu" + menuitem)
        
        
        // let order = "{\"name\": \"Pasta\"}"
        let order = String(format:"{\"name\": \"\(menuitem)\"}")
        
        
        post( url: URL(string: getApiUrl(resource: "orders"))!, input:order, callback: {
            (json) -> Void in
            
            print("ordered successfully")
        })
        
        return
        
    }
    /*
     http post utility function.
     */
    func post(url:URL, input:String, callback : @escaping ([Any]) -> Void){
        
        //var input:String = ""
        print(input)
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = input.data(using: .utf8)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    print(data as Any)
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        print(json)
                        callback(json)
                        
                    }else{
                        print("unable to deserialize.")
                    }
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
            }
            
        })
        task.resume()
        
    }
    
    /*
     http get utility function
     */
    func get(url:URL,callback : @escaping ([Any]) -> Void){
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        
                        callback(json)
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    func getApiUrl(resource:String) ->String{
        return "https://5bsr9e6203.execute-api.us-west-2.amazonaws.com/staging/" + resource
    }
}
