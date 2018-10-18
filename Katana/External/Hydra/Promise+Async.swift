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

/// This method is a shortcut to create a new Promise which, by default, will execute passed body
/// in a `background` queue (at least if you don't specify a `context`).
///
/// - Parameters:
///   - context: context in which the body should be execute
///	  - token: invalidation token you need to provide to cancel the promise
///   - body: body to execute. To fulfill the promise it should 
/// - Returns: a new promise
public func async<T>(in context: Context? = nil, token: InvalidationToken? = nil, _ body: @escaping ( (_ status: PromiseStatus) throws -> (T)) ) -> Promise<T> {
	return Promise<T>(in: context, token: token, { resolve, reject, st in
		do {
			try resolve(body(st))
		} catch {
			reject(error)
		}
	})
}

/// This is another variant of `async` which is a simple shortcut to create a new dispatch queue and
/// execute something in it. It can be used without the concept of the Promises.
///
/// - Parameters:
///   - context: context in which the block will be executed
///	  - after: allows you to specify a delay interval before executing the block itself.
///   - block: block to execute
public func async(in context: Context, after: TimeInterval? = nil, _ block: @escaping () -> ()) -> Void {
	guard let delay = after else {
		context.queue.async {
			block()
		}
		return
	}
	context.queue.asyncAfter(deadline: .now() + delay) { 
		block()
	}
}
