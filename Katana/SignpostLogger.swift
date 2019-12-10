//
//  SignpostLogger.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import os.signpost

/**
 Wrapper around the signpost API offered starting from iOS12.
 The logger will automatically track side effects, state updaters and side effects
 in Instruments. You will get a nice visualization of the operations that are ongoing,
 the parallelism level and the time that each operation requires.
 
 - seeAlso: https://developer.apple.com/documentation/os/logging
 */
public struct SignpostLogger {
  /// A closure that must be invoked when the operation is completed
  typealias LogEndClosure = () -> Void
  
  /// Whether the logging is enabled. You should invoke this before instantiating
  /// the store in your application
  public static var isEnabled = false
  
  /// The shared value of the singleton
  static var shared: SignpostLogger = SignpostLogger()
  
  /// An utility function
  static var noop: LogEndClosure = { }
  
  /// The type of operation that should be logged
  enum LogType {
    /// Log a state updater operation
    case stateUpdater
    
    /// Log a side effect operation
    case sideEffect
  }
  
  /// The `OSLog` instance that backs the logger
  let katanaLogger: OSLog?
  
  /**
   Starts to log an operation
   
   - parameter type: the type of operation
   - parameter name: a unique name associated with the log
   - returns: a closure to invoke when the related operations ends
   */
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
      }
    }
    
    return SignpostLogger.noop
  }
  
  /**
   Starts to log a state updater operation
   
   - parameter log: the underlying log to use
   - parameter name: a unique name associated with the log
   - returns: a closure to invoke when the related operations end
   */
  @available(iOS 12.0, *)
  func logStateUpdater(log: OSLog, name: String) -> LogEndClosure {
    let signpostID = OSSignpostID(log: log)
    
    os_signpost(.begin, log: log, name: "State Updater", signpostID: signpostID, "%{public}s", name)
    
    return {
      os_signpost(.end, log: log, name: "State Updater", signpostID: signpostID, "%{public}s", name)
    }
  }
  
  /**
   Starts to log a side effect operation
   
   - parameter log: the underlying log to use
   - parameter name: a unique name associated with the log
   - returns: a closure to invoke when the related operation ends
   */
  @available(iOS 12.0, *)
  func logSideEffect(log: OSLog, name: String) -> LogEndClosure {
    let signpostID = OSSignpostID(log: log)
    
    os_signpost(.begin, log: log, name: "Side Effect", signpostID: signpostID, "%{public}s", name)
    
    return {
      os_signpost(.end, log: log, name: "Side Effect", signpostID: signpostID, "%{public}s", name)
    }
  }
}

// MARK: Private
extension SignpostLogger {
  /// Creates an instance of the logger.
  /// If the `isEnabled` flag is false, then an empty logger is created
  /// (that is, a logger that does nothing)
  private init() {
    if #available(iOS 10.0, *), SignpostLogger.isEnabled {
      self.katanaLogger = OSLog(subsystem: "Katana", category: "Katana")
      
    } else {
      self.katanaLogger = nil
    }
  }
}
