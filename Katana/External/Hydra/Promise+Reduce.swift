//
//  Promise+Reduce.swift
//  Hydra
//
//  Created by Daniele Margutti on 01/02/2017.
//  Copyright © 2017 moka. All rights reserved.
//

import Foundation

/// Reduce a sequence of items with a asynchronous operation (Promise) to a single value
///
/// - Parameters:
///   - context: context in which the transform is executed (if not specified `main` is used)
///   - items: initial value to begin reducing
///   - initial: sequence to reduce
///   - transform: transform function that accepts a partial result and sequence item
/// - Returns: promise
public func reduce<A, I, S: Sequence>(in context: Context? = nil, _ items: S, _ initial: I, _ transform: @escaping (I, A) throws -> Promise<I>) -> Promise<I> where S.Iterator.Element == A {
	let ctx = context ?? .main
	let initialPromise = Promise<I>(resolved: initial)
	return items.reduce(initialPromise) { partial, item in
		return partial.then(in: ctx) {
			try transform($0, item)
		}
	}
}
