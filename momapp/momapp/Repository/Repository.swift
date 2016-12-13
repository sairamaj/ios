//
//  Repository.swift
//  momapp
//
//  Created by Sourabh Jamlapuram on 12/11/16.
//  Copyright © 2016 Sourabh Jamlapuram. All rights reserved.
//

import Foundation

class Repository{
    
    func getOrders(callback : @escaping ( [Order]) -> Void){
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://5bsr9e6203.execute-api.us-west-2.amazonaws.com/staging/order")!
        
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
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }

}
