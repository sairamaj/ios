//: Playground - noun: a place where people can play

import UIKit

var dateString = "Sun Dec 11 2016 19:16:55 GMT+0000 (UTC)"

var r = dateString.range(of: " GMT+0000 (UTC)")
dateString.removeSubrange(r!)
print(dateString)




let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss"
dateFormatter.timeZone = TimeZone(identifier: "UTC")
let orderDate = dateFormatter.date(from: dateString)
print(orderDate ?? <#default value#>)


















