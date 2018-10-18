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

/// Return a Promises that resolved when all input Promises resolves.
/// Promises are resolved in parallel in background QoS queue.
/// It rejects as soon as a promises reject for any reason; result reject with returned error.
///
/// - Parameters:
///   - promises: list of promises to resolve in parallel
/// - Returns: resolved promise which contains all resolved values from input promises (value are reported in the same order of input promises)
public func all<L>(_ promises: Promise<L>..., concurrency: UInt = UInt.max) -> Promise<[L]> {
	return all(promises, concurrency: concurrency)
}

public func all<L, S: Sequence>(_ promises: S, concurrency: UInt = UInt.max) -> Promise<[L]> where S.Iterator.Element == Promise<L> {
	guard Array(promises).count > 0, concurrency > 0 else {
		// If number of passed promises is zero we want to return a resolved promises with an empty array as result
		return Promise<[L]>(resolved: [])
	}
	
	// We want to create a Promise which groups all input Promises and return only
	// when all input promises fullfill or one of them reject.
	// Promises are resolved in parallel but the array with the results of all promises is reported
	// in the same order of the input promises.
	let allPromise = Promise<[L]> { (resolve, reject, operation) in
		var countRemaining = Array(promises).count
		var countRunningPromises: UInt = 0
		let allPromiseContext = Context.custom(queue: DispatchQueue(label: "com.hydra.queue.all"))
		
		for currentPromise in promises {
			// Listen for each promise in list to fulfill or reject
			currentPromise.add(in: allPromiseContext, onResolve: { value in
				// if currentPromise fulfill
				// decrement remaining promise to fulfill
				countRemaining -= 1
				if countRemaining == 0 {
					// if all promises are fullfilled we can resolve our chain Promise
					// with an array of all values results of our input promises (in the same order)
					let allResults = promises.map({ return $0.state.value! })
					resolve(allResults)
				} else {
					let nextPromise = promises.first(where: { $0.state.isPending && !$0.bodyCalled })
					nextPromise?.runBody()
				}
				// if currentPromise reject the entire chain is broken and we reject the group Promise itself
			}, onReject: { err in
				reject(err)
			}, onCancel: {
				operation.cancel()
			})
			if concurrency > countRunningPromises {
				currentPromise.runBody()
				countRunningPromises += 1
			}
		}
	}
	return allPromise
}

