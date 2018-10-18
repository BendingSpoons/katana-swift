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

//MARK: PromiseError

/// This is the list of standard errors provided by a Promise. You can extended this enum or
/// use another one to provide your own errors list (you must inherit from Swift's `Error` protocol).
///
/// - invalidInput: invalid input
/// - timeout: timeout reached
/// - rejected: promise rejected
/// - invalidContext: invalid context provided
/// - attemptsFailed: number of attempts reached but the promise is rejected
public enum PromiseError: Error {
	case timeout
	case rejected
	case invalidInput
	case invalidContext
	case attemptsFailed
}


/// Invalidatable protocol is used to control the execution of a promise from the outside
/// You should pass an object conforms to this type at the init of your Promsie instance.
/// To invalidate a Promise just return the `.isCancelled` property to `true`.
///
/// From the inside of your Promise's body you should check if the `operation.isCancelled` is `true`.
/// If yes you should act accordingly by stopping your execution and call `operation.invalidate()` function
/// at the end.
public protocol InvalidatableProtocol {

	/// Set to `true` in order to receive the message from the inside the Promise's body.
	var isCancelled: Bool { get }
	
}


/// This is a simple implementation of the `InvalidatableProtocol` protocol.
/// You can use or extend this class in order to provide your own bussiness logic.
open class InvalidationToken: InvalidatableProtocol {
	
	/// Current status of the promise
	public var isCancelled: Bool = false
	
	/// Call this function to mark the operation as invalid.
	public func invalidate() {
		isCancelled = true
	}
	
	/// Public init
	public init() { }
}



/// This object is passed into the Promise's body and allows you to check for the current
/// Promise status (is it valid or not) and mark it as cancelled if necessary.
/// In order to mark a Promise as `cancelled` you must call `cancel` function of this instance
/// and stop the workflow of your promise's body.

public struct PromiseStatus {
	
	/// Reference to the Promise's invalidation token
	internal var token: InvalidationToken?
	
	/// Cancel Promise workflow and mark the promise itself as `cancelled`.
	public let cancel: (() -> ())
	
	/// Check if the promise is valid by querying your provided `InvalidatableProtocol` object.
	public var isCancelled: Bool {
		get { return token?.isCancelled ?? false }
	}
	
	// Initialize a new `PromiseStatus` object.
	// You don't need to do it manually, it's done when a new `Promise` is initialized with a valida `InvalidatableProtocol`
	internal init(token: InvalidationToken? = nil, _ action: @escaping (() -> ())) {
		self.token = token
		self.cancel = action
	}
}
