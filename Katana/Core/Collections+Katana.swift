//
//  Array+Katana.swift
//  Katana
//
//  Created by Luca Querella on 12/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

extension Array where Element : Comparable {
    
    func isSorted() -> Bool {
        
        if self.count < 1 {
            return true
        }
        
        var current = self[0]
        
        for element in self {
            if element < current {
                return false
            }
            current = element
        }
        
        return true
    }
}
