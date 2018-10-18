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
	
	
	/// Catches an error in a Promise chain.
	///
	/// - Parameters:
	///   - context: context in which the body is executed (if not specified `.main` is used)
	///   - body: body to execute
	/// - Returns: a promise
	@discardableResult
	public func `catch`(in context: Context? = nil, _ body: @escaping ((Error) throws -> ())) -> Promise<Void> {
		let ctx = context ?? .main
		let nextPromise = Promise<Void>(in: ctx, token: self.invalidationToken) { resolve, reject, operation in
			let onResolve = Observer.onResolve(ctx, { _ in
				resolve(())
			})
			let onReject = Observer.onReject(ctx, { error in
				do {
					try body(error)
				} catch let error {
					reject(error)
				}
				resolve(())
			})

			let onCancel = Observer.onCancel(ctx, operation.cancel)
			
			self.add(observers: onResolve, onReject, onCancel)
		}
		nextPromise.runBody()
		self.runBody()
		return nextPromise
	}
	
}
