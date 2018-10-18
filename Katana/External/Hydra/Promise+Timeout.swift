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
	/// Reject the receiving Promise if it does not resolve or reject after a given number of seconds
	///
	/// - Parameters:
	///   - context: context in which the nextPromise will be executed (if not specified `background` is used)
	///   - timeout: timeout expressed in seconds
	///   - error: error to report, if nil `PromiseError.timeout` is used instead
	/// - Returns: promise
	public func timeout(in context: Context? = nil, timeout: TimeInterval, error: Error? = nil) -> Promise<Value> {
		let ctx = context ?? .background
		let nextPromise = Promise<Value>(in: ctx, token: self.invalidationToken) { resolve, reject, operation in
			// Dispatch the result of self promise to the nextPromise
			
			// If self promise does not resolve or reject in given amount of time
			// nextPromise is rejected with passed error or generic timeout error
			// and any other result of the self promise is ignored
			let timer = DispatchTimerWrapper(queue: ctx.queue)
			timer.setEventHandler { 
				let errorToPass = (error ?? PromiseError.timeout)
				reject(errorToPass)
			}
			timer.scheduleOneshot(deadline: .now() + timeout)
			timer.resume()
			
			// Observe resolve
			self.add(onResolve: { v in
				resolve(v) // resolve with value
				timer.cancel() // cancel timeout timer and release promise
			}, onReject: reject, onCancel: operation.cancel)
		}
		nextPromise.runBody()
		self.runBody()
		return nextPromise
	}
	
}
