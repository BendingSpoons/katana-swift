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

/// Returns a Promise that resolves as soon as one passed in Promise resolves
///
/// - Parameters:
///   - context: dispatch queue to run the handler on (if not specified `background` context is used)
///   - promises: promises to resolve
/// - Returns: Promise that resolves to first resolved Promise
public func any<L>(in context: Context? = nil, _ promises: Promise<L>...) -> Promise<L> {
	return any(promises)
}

/// Returns a Promise that resolves as soon as one passed in Promise resolves
///
/// - Parameters:
///   - context: dispatch queue to run the handler on (if not specified `background` context is used)
///   - promises: array of Promises to resolve
/// - Returns: Promise that resolves to first resolved Promise
public func any<L>(in context: Context? = nil, _ promises: [Promise<L>]) -> Promise<L> {
	guard Array(promises).count > 0 else {
		// if number of passed promises is zero a rejected promises is returned
		return Promise<L>(rejected: PromiseError.invalidInput)
	}
	let anyPromise = Promise<L> { (resolve, reject, operation) in
		for currentPromise in promises {
			// first promises which resolve is returned
			currentPromise.add(in: context, onResolve: resolve, onReject: reject, onCancel: operation.cancel)
			currentPromise.runBody()
		}
	}
	return anyPromise
}

