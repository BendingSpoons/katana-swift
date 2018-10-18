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
	
	//MARK: Promise Observer
	
	/// This enum represent an observer which receive the state of a promise.
	///
	/// - onResolve: register an handler which is executed only if target promise is fulfilled.
	/// - onReject: register an handler which is executed only if target promise is rejected.
	public indirect enum Observer {
		public typealias ResolveObserver = ((Value) -> ())
		public typealias RejectObserver = ((Error) -> ())
		public typealias CancelObserver = (() -> ())
		
		case onResolve(_: Context, _: ResolveObserver)
		case onReject(_: Context, _: RejectObserver)
		case onCancel(_: Context, _: CancelObserver)
		
		/// Call the observer by state
		///
		/// - Parameter state: State
		func call(_ state: State) {
			switch (self, state) {
			case (.onResolve(let context, let handler), .resolved(let value)):
				context.queue.async {
					handler(value)
				}
			case (.onReject(let context, let handler), .rejected(let error)):
				context.queue.async {
					handler(error)
				}
			case (.onCancel(let context, let handler), .cancelled):
				context.queue.async {
					handler()
				}
			default:
				return
			}
		}
		
	}
	
}
