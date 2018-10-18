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

public extension Promise {
	
	
	/// This `then` allows to execute a block which return a value; this value is used to get a chainable
	/// Promise already resolved with that value.
	/// Executed body can also reject the chain if throws.
	///
	/// - Parameters:
	///   - context: context in which the body is executed (if not specified `main` is used)
	///   - body: block to execute
	/// - Returns: a chainable promise
	@discardableResult
	public func then<N>(in context: Context? = nil, _ body: @escaping ( (Value) throws -> N) ) -> Promise<N> {
		let ctx = context ?? .main
		return self.then(in: ctx, { value in
			do {
				// get the value from body (or throws) and
				// create a resolved Promise with that which is returned
				// as output of the then as chainable promise.
				let transformedValue = try body(value)
				return Promise<N>(resolved: transformedValue)
			} catch let error {
				// if body throws a rejected promise with catched error is generated
				return Promise<N>(rejected: error)
			}
		})
	}
	
	
	/// This `then` allows to execute a block of code which can transform the result of the promise in another
	/// promise.
	/// It's also possible to use it in order to send the output of a promise an input of another one and use it:
	/// `asyncFunc1().then(asyncFunc2).then...`
	/// Executed body can also reject the chain if throws.
	///
	/// - Parameters:
	///   - context: context in which the body is executed (if not specified `main` is used)
	///   - body: body to execute
	/// - Returns: chainable promise
	@discardableResult
	public func then<N>(in context: Context? = nil, _ body: @escaping ( (Value) throws -> (Promise<N>) )) -> Promise<N> {
		let ctx = context ?? .main
		let nextPromise = Promise<N>(in: ctx, token: self.invalidationToken, { resolve, reject, operation in
			
			// Observe the resolve of the self promise
			let onResolve = Observer.onResolve(ctx, { value in
				do {
					// Pass the value to the body and get back a new promise
					// with another value
					let chainedPromise = try body(value)
					// execute the promise's body and get the result of it
					let pResolve = Promise<N>.Observer.onResolve(ctx, resolve)
					let pReject = Promise<N>.Observer.onReject(ctx, reject)
					chainedPromise.add(observers: pResolve, pReject)
					chainedPromise.runBody()
				} catch let error {
					reject(error)
				}
			})
			
			// Observe the reject of the self promise
			let onReject = Observer.onReject(ctx, reject)
			let onCancel = Observer.onCancel(ctx, operation.cancel)

			self.add(observers: onResolve, onReject, onCancel)
		})
		nextPromise.runBody()
		self.runBody()
		return nextPromise
	}
	
	
	/// This `then` variant allows to catch the resolved value of the promise and execute a block of code
	/// without returning anything.
	/// Defined body can also reject the next promise if throw.
	/// Returned object is a promise which is able to dispatch both error or resolved value of the promise.
	///
	/// - Parameters:
	///   - context: context in which the body is executed (if not specified `main` is used)
	///   - body: code block to execute
	/// - Returns: a chainable promise
	@discardableResult
	public func then(in context: Context? = nil, _ body: @escaping ( (Value) throws -> () ) ) -> Promise<Value> {
		let ctx = context ?? .main
		// This is the simplest `then` is possible to create; it simply execute the body of the
		// promise, get the value and allows to execute a body. Body can also throw and reject
		// next chained promise.
		let nextPromise = Promise<Value>(in: ctx, token: self.invalidationToken, { resolve, reject, operation in
			let onResolve = Observer.onResolve(ctx, { value in
				do {
					// execute body and resolve this promise with the same value
					// no transformations are allowed in this `then` except the throw.
					// if body throw nextPromise is rejected.
					try body(value)
					resolve(value)
				} catch let error {
					// body throws, this nextPromise reject with given error
					reject(error)
				}
			})

			// this promise rejects so nextPromise also rejects with the error
			let onReject = Observer.onReject(ctx, reject)
			let onCancel = Observer.onCancel(ctx, operation.cancel)
			
			self.add(observers: onResolve, onReject, onCancel)
		})
		// execute the body of nextPromise so we can register observer
		// to this promise and get back value/error once its resolved/rejected.
		nextPromise.runBody()
		// run the body of the self promise. Body is executed only one time; if this
		// promise is the main promise it simply execute the core of the promsie functions.
		self.runBody()
		return nextPromise
	}
	
}
