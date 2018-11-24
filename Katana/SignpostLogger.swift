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
  
  static var shared: SignpostLogger = SignpostLogger()
  static var noop: LogEndClosure = { }
  
  enum LogType {
    case stateUpdater, sideEffect, action
  }
  
  let stateUpdaterLog: OSLog?
  let sideEffectLog: OSLog?
  let actionLog: OSLog?
  
  func log(for logType: LogType) -> OSLog? {
    switch logType {
    case .stateUpdater:
      return self.stateUpdaterLog
    
    case .sideEffect:
      return self.sideEffectLog

    case .action:
      return self.actionLog
    }
  }
  
  func logStart(type: LogType, name: String) -> LogEndClosure {
    guard let log = self.log(for: type) else {
      return SignpostLogger.noop
    }
    
    if #available(iOS 12.0, *) {
      let signpostID = OSSignpostID(log: log)
      os_signpost(.begin, log: log, name: "", signpostID: signpostID, "%{public}s", name)
      
      return {
        os_signpost(.end, log: log, name: "", signpostID: signpostID, "%{public}s", name)
      }
    }
    
    return SignpostLogger.noop
  }
}

// MARK: Private
extension SignpostLogger {
  private init() {
    if #available(iOS 10.0, *) {
      self.stateUpdaterLog = OSLog(subsystem: "Katana", category: "State Updater")
      self.sideEffectLog = OSLog(subsystem: "Katana", category: "Side Effect")
      self.actionLog = OSLog(subsystem: "Katana", category: "Action")
      
    } else {
      self.stateUpdaterLog = nil
      self.sideEffectLog = nil
      self.actionLog = nil
    }
  }
}
