//
//  Repository.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 12/11/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

class Repository{
    
    /*
     class communicates to aws REST api for mom restaurant items
     */
    public static let shared:Repository = {
        return Repository()
    }()
    
    /*
     Cannot create instance. (singleton pattern)
     */
    private init(){
        
    }
    
    func getOrders(callback : @escaping ( [Order]) -> Void){
        get( url: URL(string: getApiUrl(resource: "orders"))!, callback: {
            (json) -> Void in
            
            var orders = [Order]()
            
            for m in json{
                if let dictionary = m as? [String: Any] {
                    /*
                     Json response:
                     [
                     {
                     confirmationId = Lc8sz74oRZpzOK1;
                     date = "Sun Dec 11 2016 19:16:55 GMT+0000 (UTC)";
                     menuitem = Burrito;
                     },
                     
                     {
                     confirmationId = aXDuSTks54aR8QT;
                     date = "Sun Dec 11 2016 18:07:54 GMT+0000 (UTC)";
                     menuitem = Pasta;
                     }
                     ]
                     */
                    var dateString = dictionary["date"] as! String
                    
                    // right now I am not able to convert string which hcas GMT and UTC to Date object
                    // stripping those characters and useing date formatter
                    // once I know how to format with these we can format directly instead of stripping
                    let r = dateString.range(of: " GMT+0000 (UTC)")
                    dateString.removeSubrange(r!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(identifier: "UTC")
                    let orderDate = dateFormatter.date(from: dateString)
                    
                    let order:Order = Order(menuItem: dictionary["menuitem"] as! String, date: orderDate!, confirmationId: dictionary["confirmationId"] as! String)
                    orders.append(order )
                    
                }
            }
            
            callback(orders)

            
        })

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
    
    func saveMenuItem(menuitem : String) {
        print("saving menu" + menuitem)
        
        let saveMenuItem = String(format:"{\"name\": \"\(menuitem)\"}")
        
        
        post( url: URL(string: getApiUrl(resource: "menuitems"))!, input:saveMenuItem, callback: {
            (json) -> Void in
            
            print("menuitem was saved successfully")
        })
    }
    
    func removeMenuItem(menuitem : String) {
        
        
        let deleteMenuItem = String(format:"{\"name\": \"\(menuitem)\"}")
        
        
        delete( url: URL(string: getApiUrl(resource: "menuitems"))!, input:deleteMenuItem, callback: {
            (json) -> Void in
            
            print("menuitem was deleted successfully")
        })

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
     http post utility function.
     */
    func delete(url:URL, input:String, callback : @escaping ([Any]) -> Void){
        
        //var input:String = ""
        print(input)
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
    
    func getApiUrl(resource:String) ->String{
        return "https://5bsr9e6203.execute-api.us-west-2.amazonaws.com/staging/" + resource
    }
}
