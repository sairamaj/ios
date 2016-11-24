//
//  RestaurantRepository.swift
//  MomRestaurant
//
//  Created by Sourabh Jamlapuram on 11/18/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

class RestaurantRepository{
    
    func getMenuItems(callback : @escaping ( [String]) -> Void){
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://5bsr9e6203.execute-api.us-west-2.amazonaws.com/staging/menu")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any]
                    {
                        
                        //Implement your logic
                        print(json)
                        var items = [String]()

                        for m in json{
                            if let dictionary = m as? [String: Any] {
                                items.append( dictionary["name"] as! String)
                            }
                        }
                        
                       callback(items)
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
        

    }
}
