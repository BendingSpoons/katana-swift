//
//  AnyStore.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyStore: class {
  func dispatch(_ action: Action)
  func addListener(_ listener: StoreListener) -> StoreUnsubscribe
  // the name is not getState because otherwise we cannot use inferred types anymore
  // since getState can also return any
  func getAnyState() -> Any
}
