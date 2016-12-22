//
//  ArrayExtension.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 12/21/14.
//  Copyright (c) 2014 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

extension Array{
    func first(fn: (T, Int) -> Bool) -> T? {
        var i = 0
        for x in self {
            let t = x as T
            if fn(t, i++) {
                return t
            }
        }
            return nil
    }
    
    func any(fn: (T) -> Bool) -> Bool {
        return self.find(fn).count > 0
    }
    
    
    func find(fn: (T) -> Bool) -> [T] {
        var to = [T]()
        for x in self {
            let t = x as T
            if fn(t) {
                to.append(t)
            }
        }
        return to
    }
    
    func find(fn: (T, Int) -> Bool) -> [T] {
        var to = [T]()
        var i = 0
        for x in self {
            let t = x as T
            if fn(t, i++) {
                to.append(t)
            }
        }
        return to
    }
    
    func forEach(doThis: (element: T) -> Void) {
        for e in self {
            doThis(element: e)
        }
    }
    
}
