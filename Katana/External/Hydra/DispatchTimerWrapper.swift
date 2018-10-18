//
//  DispatchTimerWrapper.swift
//  This class was originally created with ProcedureKit project.
//  Hydra
//
//  Created by dan on 29/08/2017.
//  Copyright © 2017 Hydra. All rights reserved.
//

import Foundation
import Dispatch

// A wrapper for a DispatchSourceTimer that ensures that the timer is cancelled
// and not suspended prior to deinitialization.

internal class DispatchTimerWrapper {
	typealias EventHandler = @convention(block) () -> Swift.Void
	private let timer: DispatchSourceTimer
	private let lock = NSLock()
	private var didResume = false
	
	init(queue: DispatchQueue) {
		timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
	}
	
	deinit {
		// ensure that the timer is cancelled and resumed before deiniting
		// (trying to deconstruct a suspended DispatchSource will fail)
		timer.cancel()
		lock.withCriticalScope {
			guard !didResume else { return }
			timer.resume()
		}
	}
	
	// MARK: - DispatchSourceTimer methods
	func setEventHandler(qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], handler: @escaping EventHandler) {
		timer.setEventHandler(qos: qos, flags: flags, handler: handler)
	}
	
	func setEventHandler(handler: DispatchWorkItem) {
		timer.setEventHandler(handler: handler)
	}
	
	func scheduleOneshot(deadline: DispatchTime, leeway: DispatchTimeInterval = .nanoseconds(0)) {
		timer.schedule(deadline: deadline, leeway: leeway)
	}
	
	func resume() {
		lock.withCriticalScope {
			guard !didResume else { fatalError("Do not call resume() twice.") }
			timer.resume()
			didResume = true
		}
	}
	
	func cancel() {
		timer.cancel()
	}
}

internal extension NSLock {
	
	/// Convenience API to execute block after acquiring the lock
	///
	/// - Parameter block: the block to run
	/// - Returns: returns the return value of the block
	func withCriticalScope<T>(block: () -> T) -> T {
		lock()
		let value = block()
		unlock()
		return value
	}
}
