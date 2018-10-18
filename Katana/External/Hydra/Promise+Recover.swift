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
	
	/// Allows you to recover a failed promise by returning another promise with the same output
	///
	/// - Parameters:
	///   - context: context in which the body is executed (if not specified `background` is used)
	///   - body: body to execute. It must return a new promise to evaluate (our recover promise)
	/// - Returns: a promise
	public func recover(in context: Context? = nil, _ body: @escaping (Error) throws -> Promise<Value>) -> Promise<Value> {
		let ctx = context ?? .background
		return Promise<Value>(in: ctx, token: self.invalidationToken, { resolve, reject, operation in
			return self.then(in: ctx, {
				// If promise resolve we don't need to do anything.
				resolve($0)
			}).catch(in: ctx, { error in
				// If promise fail we allows the user to recover it by executing body.
				// Body could return a new valid Promise of the same type or
				// throws and reject the attempt.
				do {
					try body(error).then(in: ctx, resolve).catch(in: ctx, reject)
				} catch (let error) {
					reject(error)
				}
			}).cancelled(in: ctx, { () -> Void in
				operation.cancel()
			})
		})
	}

	
}
