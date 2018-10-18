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
	
	/// `retry` operator allows you to execute source chained promise if it ends with a rejection.
	/// If reached the attempts the promise still rejected chained promise is also rejected along with
	/// the same source error.
	///
	/// - Parameters:
	///   - attempts: number of retry attempts for source promise (must be a number > 1, otherwise promise is rejected with `PromiseError.invalidInput` error.
	///   - condition: code block to check retryable source promise
	/// - Returns: a promise which resolves when the first attempt to resolve source promise is succeded, rejects if none of the attempts ends with a success.
    public func retry(_ attempts: Int = 3, _ condition: @escaping ((Int, Error) throws -> Bool) = { _,_ in true }) -> Promise<Value> {
		guard attempts >= 1 else {
			// Must be a valid attempts number
			return Promise<Value>(rejected: PromiseError.invalidInput)
		}
		
		var innerPromise: Promise<Value>? = nil
		var remainingAttempts = attempts
		// We'll create a next promise which will be resolved when attempts to resolve self (source promise)
		// is reached (with a fulfill or a rejection).
		let nextPromise = Promise<Value>(in: self.context, token: self.invalidationToken) { (resolve, reject, operation) in
			innerPromise = self.recover(in: self.context) { [unowned self] (error) -> (Promise<Value>) in
				// If promise is rejected we'll decrement the attempts counter
				remainingAttempts -= 1
				guard remainingAttempts >= 1 else {
					// if the max number of attempts is reached
					// we will end nextPromise with the last seen error
					throw error
				}
				// If promise is rejected we will check condition that is retryable
				do {
					guard try condition(remainingAttempts, error) else {
						throw error
					}
				} catch(_) {
					// reject soruce promise error
					throw error
				}
				// Reset the state of the promise
				// (okay it's true, a Promise cannot change state as you know...this
				// is a bit trick which will remain absolutely internal to the library itself)
				self.resetState()
				// Re-execute the body of the source promise to re-execute the async operation
				self.runBody()
				return self.retry(remainingAttempts, condition)
			}
			// If promise resolves nothing else to do, resolve the nextPromise!
			let onResolve = Observer.onResolve(self.context, resolve)
			let onReject = Observer.onReject(self.context, reject)
			let onCancel = Observer.onCancel(self.context, operation.cancel)
			
			// Observe changes from source promise
			innerPromise?.add(observers: onResolve, onReject, onCancel)
			innerPromise?.runBody()
		}
		nextPromise.runBody()
		return nextPromise
	}
	
}
