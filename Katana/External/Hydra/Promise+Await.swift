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

/// Concurrent queue context in which awaits func works
/// Concurrent queues (also known as a type of global dispatch queue) execute one or more tasks concurrently
/// but tasks are still started in the order in which they were added to the queue.
/// The currently executing tasks run on distinct threads that are managed by the dispatch queue.
/// The exact number of tasks executing at any given point is variable and depends on system conditions.
let awaitContext = Context.custom(queue: DispatchQueue(label: "com.hydra.awaitcontext", attributes: .concurrent))

/// This define a `..` operator you can use instead of calling `await` func.
/// If you use this operator you need to also use `do/catch` in order to catch exception for rejected promises.
prefix operator ..
public prefix func ..<T> (_ promise: Promise<T>) throws -> T {
	return try awaitContext.await(promise)
}

// This define a `..!` operator you can use instead of calling `await`.
// Using this operator if promise is rejected for any reason the result is `nil` and no throws is called.
prefix operator ..!
public prefix func ..!<T> (_ promise: Promise<T>) -> T? {
	do {
		return try awaitContext.await(promise)
	} catch {
		return nil
	}
}

/// Awaits that the given promise fulfilled with its value or throws an error if the promise fails
///
/// - Parameters:
///   - context: context in which you want to execute the operation. If not specified default concurrent `awaitContext` is used instead.
///   - promise: target promise
/// - Returns: fufilled value of the promise
/// - Throws: throws an exception if promise fails due to an error
@discardableResult
public func await<T>(in context: Context? = nil, _ promise: Promise<T>) throws -> T {
	return try (context ?? awaitContext).await(promise)
}

/// Awaits that the given body is resolved. This is a shortcut which simply create a Promise; as for a Promise you need to
/// call `resolve` or `reject` in order to complete it.
///
/// - Parameters:
///   - context: context in which the body is executed (if not specified `background` is used)
///   - body: closure to execute
/// - Returns: the value of the promise
/// - Throws: an exception if operation fails
@discardableResult
public func await<T>(in context: Context = .background, _ body: @escaping ((_ fulfill: @escaping (T) -> (), _ reject: @escaping (Error) -> (), _ operation: PromiseStatus) throws -> ())) throws -> T {
	let promise = Promise<T>(in: context, body)
	return try await(in: context, promise)
}


// MARK: - Extension of Context

public extension Context {
	
	///  Awaits that the given promise fulfilled with its value or throws an error if the promise fails.
	///
	/// - Parameter promise: target promise
	/// - Returns: return the value of the promise
	/// - Throws: throw if promise fails
	@discardableResult
	internal func await<T>(_ promise: Promise<T>) throws -> T {
		guard self.queue != DispatchQueue.main else {
			// execute a promise on main context does not make sense
			// dispatch_semaphore_wait should NOT be called on the main thread.
			// more here: https://medium.com/@valentinkalchev/how-to-pause-and-resume-a-sequence-of-mutating-swift-structs-using-dispatch-semaphore-fc98eca55c0#.ipbujy4k2
			throw PromiseError.invalidContext
		}
		
		var result: T?
		var error: Error?
		
		// Create a semaphore to block the execution of the flow until
		// the promise is fulfilled or rejected
		let semaphore = DispatchSemaphore(value: 0)
		
		promise.then(in: self) { value -> Void in
			// promise is fulfilled, fillup error and resume code execution
			result = value
			semaphore.signal()
		}.catch(in: self) { err in
			// promise is rejected, fillup error and resume code execution
			error = err
			semaphore.signal()
		}
	
		// Wait and block code execution until promise is fullfilled or rejected
		_ = semaphore.wait(timeout: .distantFuture)
		
		guard let promiseValue = result else {
			throw error!
		}
		return promiseValue
	}
}
