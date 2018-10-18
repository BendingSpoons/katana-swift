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
	
	
	/// Join two promises and return a tuple with the results of both (promises will be resolved in parallel in `background` QoS queue).
	/// Rejects as soon one promise reject.
	///
	/// - Parameters:
	///   - context: context queue to report the result (if not specified `background` queue is used instead)
	///   - a: promise a
	///   - b: promise b
	/// - Returns: joined promise of type Promise<(A,B)>
	public static func zip<A, B>(in context: Context? = nil, _ a: Promise<A>, _ b: Promise<B>) -> Promise<(A,B)> {
		return all(a.void,b.void).then(in: context, { _ in
			return Promise<(A, B)>(resolved: (a.state.value!, b.state.value!))
		})
	}
	
	
	/// Join three promises and return a tuple with the results of the three passed promises (promises will be resolved in parallel in `background` QoS queue).
	/// Rejects as soon one promise reject.
	///
	/// - Parameters:
	///   - context: context queue to report the result (if not specified `background` queue is used instead)
	///   - a: promise a
	///   - b: promise b
	///   - c: promise c
	/// - Returns: joined promise of type Promise<(A,B,C)>
	public static func zip<A,B,C>(in context: Context? = nil, a: Promise<A>, b: Promise<B>, c: Promise<C>) -> Promise<(A,B,C)> {
		return all(a.void,b.void,c.void).then(in: context, { _ in
			return Promise<(A, B, C)>(resolved: (a.state.value!, b.state.value!, c.state.value!))
		})
	}
	
	
	/// Join four promises and return a tuple with the results of the four promises passed (promises will be resolved in parallel in `background` QoS queue).
	/// Rejects as soon one promise reject.
	///
	/// - Parameters:
	///   - context: context queue to report the result (if not specified `background` queue is used instead)
	///   - a: promise a
	///   - b: promsie b
	///   - c: promise c
	///   - d: promise d
	/// - Returns: joined promise of type Promise<(A,B,C,D)>
	public static func zip<A,B,C,D>(in context: Context? = nil, a: Promise<A>, b: Promise<B>, c: Promise<C>, d: Promise<D>) -> Promise<(A,B,C,D)> {
		return all(a.void,b.void,c.void,d.void).then(in: context, { _ in
			return Promise<(A, B, C, D)>(resolved: (a.state.value!, b.state.value!, c.state.value!, d.state.value!))
		})
	}
	
}
