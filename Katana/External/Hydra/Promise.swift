/*
* Hydra
* Fullfeatured lightweight Promise & Await Library for Swift
*
* Created by:	Daniele Margutti
* Email:		hello@danielemargutti.com
* Web:			http://www.danielemargutti.com
* Twitter:		@danielemargutti
*
* Copyright © 2017 Daniele Margutti
*
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

import Foundation

public class Promise<Value> {
	
	public typealias Resolved = (Value) -> ()
	public typealias Rejector = (Error) -> ()
	public typealias Body = ((_ resolve: @escaping Resolved, _ reject: @escaping Rejector, _ promise: PromiseStatus) throws -> ())

	/// State of the Promise. Initially a promise has a `pending` state.
	internal var state: State = .pending
	
	/// This is the queue used to ensure thread safety on Promise's `state`.
	internal let stateQueue = DispatchQueue(label: "com.mokasw.promise")
	
	/// Body of the promise.
	/// This define the real core of your async function.
	/// Promise's `body` is not executed until you chain an operator to it (ex. `.then` or `.catch`)
	private var body: Body?
	
	/// Context (GCD queue) in which the body of the promise is executed
	/// By default background queue is used.
	private(set) var context: Context = Context.custom(queue: DispatchQueue.global(qos: .background))
	
	/// Observers of the promise; define a callback called in specified context with the result of resolve/reject of the promise
	private var observers: [Observer] = []
	
	/// Is body of the promise called
	/// It's used to prevent multiple call of the body on operators chaining
	internal var bodyCalled: Bool = false
	
	/// Optional promise identifier
	public var name: String?
	
	//internal var operation: PromiseStatus
	internal var invalidationToken: InvalidationToken? = nil
	
	/// This is the object sent to Promise's body to capture the status and
	/// eventually manage any cancel task.
	public lazy var operation: PromiseStatus = {
		return PromiseStatus(token: self.invalidationToken, { [weak self] () -> () in
			self?.set(state: .cancelled)
		})
	}()
	
	/// Thread safe current result of the promise.
	/// It contains a valid value only if promise is resolved, otherwise it's `nil`.
	public var result: Value? {
		return stateQueue.sync {
			return self.state.value
		}
	}
	
	/// Thread safe current error of the promise.
	/// It contains the error of the promise if it's currently in a `rejected` state, otherwise it's `nil`.
	public var error: Error? {
		return stateQueue.sync {
			return self.state.error
		}
	}
	
	/// Thread safe property which return if the promise is currently in a `pending` state.
	/// A pending promise it's a promise which is not resolved yet.
	public var isPending: Bool {
		return stateQueue.sync {
			return self.state.isPending
		}
	}
	
	
	/// Thread safe property which return if `body` of the promise is already called or not.
	private var isBodyExecuted: Bool {
		return stateQueue.sync {
			return self.bodyCalled
		}
	}
	
	
	/// Initialize a new Promise in a resolved state with given value.
	///
	/// - Parameter value: value to set
	public init(resolved value: Value) {
		self.state = .resolved(value)
		self.bodyCalled = true
	}
	
	
	/// Initialize a new Promise in a rejected state with a specified error
	///
	/// - Parameter error: error to set
	public init(rejected error: Error) {
		self.state = .rejected(error)
		self.bodyCalled = true
	}
	
	
	/// Initialize a new Promise which specify a `body` to execute in specified `context`.
	/// A `context` is a Grand Central Dispatch queue which allows you to control the QoS of the execution
	/// and the thread in which it must be executed in.
	///
	/// - Parameters:
	///   - context: context in which the body of the promise is executed. If `nil` global background queue is used instead
	///   - body: body of the promise, define the code executed by the promise itself.
	public init(in context: Context? = nil, token: InvalidationToken? = nil, _ body: @escaping Body) {
		self.invalidationToken = token
		self.state = .pending
		self.context = context ?? Context.custom(queue: DispatchQueue.global(qos: .background))
		self.body = body
	}
	
	/// Deallocation cleanup
	deinit {
		stateQueue.sync {
			self.observers.removeAll()
		}
	}
	
	/// Run the body of the promise if necessary
	/// In order to be runnable, the state of the promise must be pending and the body itself must not be called another time.
	internal func runBody() {
		self.stateQueue.sync {
			if !state.isPending || bodyCalled {
				return
			}
			bodyCalled = true
			
			// execute the body into given context's gcd queue
			self.context.queue.async {
				do {
					// body can throws and fail. throwing a promise's body is equal to
					// reject it with the same error.
					try self.body?( { value in
						self.set(state: .resolved(value)) // resolved
					}, { err in
						self.set(state: .rejected(err)) // rejected
					}, self.operation)
				} catch let err {
					self.set(state: .rejected(err)) // rejected (using throw)
				}
			}
		}
	}
	
	public func cancel() {
		self.set(state: .cancelled)
	}
	
	public var isCancelled: Bool {
		get { return self.invalidationToken?.isCancelled ?? false }
	}
	
	/// Thread safe Promise's state change function.
	/// Once the state did change all involved registered observer will be called.
	///
	/// - Parameter newState: new state to set
	private func set(state newState: State) {
		self.stateQueue.sync {
			// a promise state can be changed only if the current state is pending
			// once resolved or rejected state cannot be change further.
			guard self.state.isPending else {
				return
			}
			self.state = newState // change state
			self.observers.forEach { observer in
				observer.call(self.state)
			}
			self.observers.removeAll()
		}
	}
	
	
	/// Allows to register two observers for resolve/reject.
	/// A promise's observer is called when a promise's state did change.
	/// If promise's state did change to `rejected` only observers registered for `rejection` are called; viceversa
	/// if promise's state did change to `resolved` only observers registered for `resolve` are called.
	///
	/// - Parameters:
	///   - context: context in which specified resolve/reject observers is called
	///   - onResolve: observer to add for resolve
	///   - onReject: observer to add for
	internal func add(in context: Context? = nil,
	                  onResolve: @escaping Observer.ResolveObserver,
	                  onReject: @escaping Observer.RejectObserver,
	                  onCancel: Observer.CancelObserver? = nil) {
		let ctx = context ?? .background
		let onResolve = Observer.onResolve(ctx, onResolve)
		let onReject = Observer.onReject(ctx, onReject)
		let onCancel = (onCancel != nil ? Observer.onCancel(ctx, onCancel!) : nil)
		
		self.add(observers: onResolve, onReject, onCancel)
	}
	
	
	/// Allows to register promise's observers.
	/// A promise's observer is called when a promise's state did change.
	/// You can create an observer called when promise did resolve (`Observer<Value>.ResolveObserver`) or reject
	/// (`Observer<Value>.RejectObserver`).
	/// Each registered observer can be called in a specified context.
	///
	/// - Parameter observers: observers to register
	internal func add(observers: Observer?...) {
		self.stateQueue.sync {
			observers.forEach({ if let observer = $0 { self.observers.append(observer) } })
			if self.state.isPending {
				return
			}
			self.observers.forEach { observer in
				observer.call(self.state)
			}
			self.observers.removeAll()
		}
	}

	
	/// Transform given promise to a void promise.
	@available(*, deprecated: 0.9.8, message: "Use .void var instead")
	public func voidPromise() -> Promise<Void> {
		return self.then { _ in
			return ()
		}
	}
	
	/// Transform given promise to a void promise
	/// This is useful when you need to execute multiple promises which has different return values
	/// For example you can do:
	/// ```
	///		let op_1: Promise<User> = asyncGetCurrentUserProfile()
	///		let op_2: Promise<UIImage> = asyncGetCurrentUserAvatar()
	///		let op_3: Promise<[User]> = asyncGetCUrrentUserFriends()
	///		all(op_1.void,op_2.void,op_3.void).then { _ in
	///			let userProfile = op_1.result
	///			let avatar = op_2.result
	///			let friends = op_3.result
	///		}.catch { err in
	///			// do something
	///		}
	///
	/// - Returns: promise
	public var void: Promise<Void> {
		return self.then { _ in
			return ()
		}
	}
	
	/// Reset the state of the promise
	internal func resetState() {
		self.stateQueue.sync {
			self.bodyCalled = false
			self.state = .pending
		}
	}
}
