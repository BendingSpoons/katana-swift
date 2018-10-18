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
	
	/// Always run given body at the end of a promise chain regardless of the whether the chain resolves or rejects.
	///
	/// - Parameters:
	///   - context: context in which the body is executed (if not specified `background` is used)
	///   - body: body to execute
	/// - Returns: promise
	@discardableResult
	public func always(in context: Context? = nil, body: @escaping () throws -> Void) -> Promise<Value> {
		let ctx = context ?? .background
		let nextPromise = Promise<Value>(in: ctx, token: self.invalidationToken) { resolve, reject, operation in
			// Always call body both for reject and resolve
			let onResolve = Observer.onResolve(ctx, { value in
				do {
					try body()
					resolve(value)
				} catch let err {
					reject(err)
				}
			})
			
			let onReject = Observer.onReject(ctx, { error in
				do {
					try body()
					reject(error)
				} catch let err {
					reject(err)
				}
			})
			
			let onCancel = Observer.onCancel(ctx, operation.cancel)
			
			self.add(observers: onResolve, onReject, onCancel)
		}
		nextPromise.runBody()
		self.runBody()
		return nextPromise
	}
	
}
