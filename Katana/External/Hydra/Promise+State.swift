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

extension Promise {
	
	//MARK: Promise State
	
	/// This represent the state of a Promise
	///
	/// - pending: pending state. Promise was not evaluated yet.
	/// - fulfilled: final state. Promise was fulfilled with expected value instance.
	/// - rejected: final state. Promise was rejected with given error.
	internal indirect enum State {
		case pending
		case resolved(_: Value)
		case rejected(_: Error)
		case cancelled
		
		/// Resolved `value` associated with the state. `nil` if the state is not `resolved`.
		var value: Value? {
			guard case .resolved(let value) = self else { return nil }
			return value
		}
		
		/// Error associated with the state. `nil` if the state is not `rejected`.
		var error: Error? {
			guard case .rejected(let error) = self else { return nil }
			return error
		}
		
		/// Return `true` if the promise is in `pending` state, `false` otherwise.
		var isPending: Bool {
			guard case .pending = self else { return false }
			return true
		}
		
		var isCancelled: Bool {
			guard case .cancelled = self else { return false }
			return true
		}
	}
	
}
