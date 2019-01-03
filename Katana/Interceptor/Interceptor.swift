//
//  Interceptor.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 Typealias for the function that is invoked to continue with the interceptors
 chains.
*/
public typealias StoreInterceptorNext = (_: Dispatchable) throws -> Void

/**
 An interceptor is like a catch-all system that can be used to implement
 functionalities such as logging, or to dynamically change the behaviour of
 the store. An interceptor is invoked every time something has been dispatched and it is about to
 be handled.
 
 #### Initialization
 When the store is initialised, the first closure is invoked and the interceptor receives the
 context passed to the side effects. The interceptor can later use this context to retrieve the
 state or to dispatch new items.
 
 This step is performed once in the store lifetime.
 
 #### Receiving Next
 When the dispatchable is about to be handled, the store invokes the second function and passes `next`
 to the interceptor. `Next` is a generic way to pass the next step of the interceptors chaining.
 
 The interceptor should save this value and use it in the next step.
 
 This step is performed multiple times in the store lifetime, once for each dispatchable item handled
 by the store.
 
 #### Receiving the dispatchable
 Before handling the dispatchable (e.g., update the state in case of a `StateUpdater`). The last closure
 is invoked.
 
 Here the interceptor can do anything it needs to in order to implement the desired behaviour. Eventually, though, it
 should either invoke next passing the dispatchable (that is, the chain continues) or throw an error, which
 will reject the related promise and will make so that the operation related to the dispatchable is not performed.
 
 The `next` method can be also invoked with a different dispatchable with respect to the received one.
 
 This step is performed multiple times in the store lifetime, once for each dispatchable item handled
 by the store.
*/
public typealias StoreInterceptor =
  (_ sideEffectContext: AnySideEffectContext) ->
  (_ next: @escaping StoreInterceptorNext) ->
  (_ dispatchable: Dispatchable) throws -> ()
