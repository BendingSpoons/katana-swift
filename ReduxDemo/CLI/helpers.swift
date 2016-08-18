//
//  helpers.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

func aksQuestion<T>(_ question: String, error: String, until checkFn: (String) -> T?) -> T {
  var result: T? = nil
  
  repeat {
    print(question)
    let input = readLine()
    
    if let input = input {
      result = checkFn(input)
    }
    
    if result == nil {
      print(error)
    }
    
  } while(result == nil)
  
  return result!
}
