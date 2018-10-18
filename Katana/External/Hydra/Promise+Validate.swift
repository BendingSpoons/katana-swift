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
	
	/// This operator allows you to validate the result of `self` promise.
	/// It exposes a block where you can return `true` or `false` (or `throw`).
	/// If validation returns `true` promise is validated and the result is propagated over.
	/// If validation returns `false` (or `throws`) promise is rejected and the error is propagated over.
	///
	/// - Parameters:
	///   - context: context in which the validate is executed (if not specified `background` is used)
	///   - validate: validate block
	/// - Returns: promise
	public func validate(in context: Context? = nil, _ validate: @escaping ((Value) throws -> (Bool))) -> Promise<Value> {
		let ctx = context ?? .background
		return self.then(in: ctx, { (value: Value) -> Value in
			guard try validate(value) else {
				throw PromiseError.rejected
			}
			return value
		})
	}
	
}
