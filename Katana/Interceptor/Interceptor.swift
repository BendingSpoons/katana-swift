//
//  Interceptor.swift
//  Katana
//
//  Copyright © 2018 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.
//

import Foundation

public typealias StoreInterceptorNext = (_: Dispatchable) throws -> Void

public typealias StoreInterceptor =
  (_ sideEffectDependencies: AnySideEffectContext) ->
  (_ next: @escaping StoreInterceptorNext) ->
  (_ dispatchable: Dispatchable) throws -> ()
