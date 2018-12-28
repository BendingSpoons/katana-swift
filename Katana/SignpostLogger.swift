//
//  SignpostLogger.swift
//  Katana
//
//  Created by Mauro Bolis on 24/11/2018.
//

import Foundation
import os.signpost

struct SignpostLogger {
  typealias LogEndClosure = () -> Void
  
  public static var isEnabled = false
  
  static var shared: SignpostLogger = SignpostLogger()
  static var noop: LogEndClosure = { }
  
  enum LogType {
    case stateUpdater, sideEffect, action
  }
  
  let katanaLogger: OSLog?
  
  func logStart(type: LogType, name: String) -> LogEndClosure {
    guard let log = self.katanaLogger else {
      return SignpostLogger.noop
    }
    
    if #available(iOS 12.0, *) {
      switch type {
      case .stateUpdater:
        return self.logStateUpdater(log: log, name: name)
        
      case .sideEffect:
        return self.logSideEffect(log: log, name: name)
        
      case .action:
        return self.logAction(log: log, name: name)
      }
    }
    
    return SignpostLogger.noop
  }
  
  @available(iOS 12.0, *)
  func logStateUpdater(log: OSLog, name: String) -> LogEndClosure {
    let signpostID = OSSignpostID(log: log)
    
    os_signpost(.begin, log: log, name: "State Updater", signpostID: signpostID, "%{public}s", name)
    
    return {
      os_signpost(.end, log: log, name: "State Updater", signpostID: signpostID, "%{public}s", name)
    }
  }
  
  @available(iOS 12.0, *)
  func logSideEffect(log: OSLog, name: String) -> LogEndClosure {
    let signpostID = OSSignpostID(log: log)
    
    os_signpost(.begin, log: log, name: "Side Effect", signpostID: signpostID, "%{public}s", name)
    
    return {
      os_signpost(.end, log: log, name: "Side Effect", signpostID: signpostID, "%{public}s", name)
    }
  }
  
  @available(iOS 12.0, *)
  func logAction(log: OSLog, name: String) -> LogEndClosure {
    let signpostID = OSSignpostID(log: log)
    
    os_signpost(.begin, log: log, name: "Action", signpostID: signpostID, "%{public}s", name)
    
    return {
      os_signpost(.end, log: log, name: "Action", signpostID: signpostID, "%{public}s", name)
    }
  }
}

// MARK: Private
extension SignpostLogger {
  private init() {
    if #available(iOS 10.0, *), SignpostLogger.isEnabled {
      self.katanaLogger = OSLog(subsystem: "Katana", category: "Katana")
      
    } else {
      self.katanaLogger = nil
    }
  }
}
