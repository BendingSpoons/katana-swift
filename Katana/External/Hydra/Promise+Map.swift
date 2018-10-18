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

/// Promise resolve tryp
///
/// - parallel: resolve all promises in parallel
/// - series: resolve all promises in series, in order
public enum PromiseResolveType {
	case parallel
	case series
}

/// Map an array of items and transform it to Promises.
/// Then promises can be resolved in parallel or serially; rejects as soon as any Promise rejects.
///
/// - Parameters:
///   - context: context to run the handler on (if not specified `background` context is used)
///   - type: type of execution
///   - items: items to transform
///   - transform: transform callback which return the promise
/// - Returns: a Promise which resolve all created promises
public func map<A, B, S: Sequence>(_ context: Context? = nil, as type: PromiseResolveType, _ items: S, _ transform: @escaping (A) throws -> Promise<B>) -> Promise<[B]> where S.Iterator.Element == A {
	
	let ctx = context ?? .background
	switch type {
	case .parallel:
		return map_parallel(context: ctx, items: items, transform: transform)
	default:
		return map_series(context: ctx, items: items, transform: transform)
	}
}


/// Series version of the map operator
///
/// - Parameters:
///   - context: context to run the handler on (if not specified `background` context is used)
///   - items: items to transform
///   - transform: transform callback which return the promise
/// - Returns: a Promise which resolve all created promises
public func map_series<A, B, S: Sequence>(context: Context, items: S, transform: @escaping (A) throws -> Promise<B>) -> Promise<[B]> where S.Iterator.Element == A {
	let initial = Promise<[B]>(resolved: [])
	
	return items.reduce(initial) { chain, item in
		return chain.then(in: context) { results in
			try transform(item).then(in: context) { results + [$0] }
		}
	}
}

/// Parallel version of the map operator
///
/// - Parameters:
///   - context: context to run the handler on (if not specified `background` context is used)
///   - items: items to transform
///   - transform: transform callback which return the promise
/// - Returns: a Promise which resolve all created promises
internal func map_parallel<A, B, S: Sequence>(context: Context, items: S, transform: @escaping (A) throws -> Promise<B>) -> Promise<[B]> where S.Iterator.Element == A {
	
	let transformPromise = Promise<Void>(resolved: ())
	return transformPromise.then(in: context) { () -> Promise<[B]> in
		do {
			let mappedPromises: [Promise<B>] = try items.map({ item in
				return try transform(item)
			})
			return all(mappedPromises)
		} catch let error {
			return Promise<[B]>(rejected: error)
		}
	}
}

