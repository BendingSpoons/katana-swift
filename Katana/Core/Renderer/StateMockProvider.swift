//
//  StateMockProvider.swift
//  Katana
//
//  Created by Mauro Bolis on 02/04/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation

public class StateMockProvider {
  
  fileprivate var mocks: [String: [(filter: AnyFilterClosure, state: Any)]]
  
  public typealias FilterClosure<N: NodeDescription> = (_ props: N.PropsType) -> Bool

  public init() {
    self.mocks = [:]
  }

  public func mockState<N: NodeDescription>(
    _ mockedState: N.StateType,
    for descriptionType: N.Type,
    passing filter: @escaping FilterClosure<N>) {
    
    let descriptionStringName = String(reflecting: descriptionType.self)
    let anyFilter = AnyFilterClosure(descriptionType, filter: filter)
    
    if var descriptionMocks = self.mocks[descriptionStringName] {
      descriptionMocks.append((filter: anyFilter, state: mockedState))
      self.mocks[descriptionStringName] = descriptionMocks
    
    } else {
      self.mocks[descriptionStringName] = [(filter: anyFilter, state: mockedState)]
    }
  }
  
  func state<N: NodeDescription>(for descriptionType: N.Type, props: N.PropsType) -> N.StateType? {
    let descriptionStringName = String(reflecting: descriptionType.self)
    
    guard let possibleStates = self.mocks[descriptionStringName] else {
      return nil
    }
    
    return possibleStates
      .first(where: { item -> Bool in
        return item.filter.pass(descriptionType, props: props)
      })
      .flatMap { $0.state as? N.StateType }
  }
    
}

fileprivate struct AnyFilterClosure {
  private let filter: Any
  
  init<N: NodeDescription>(_ description: N.Type, filter: @escaping StateMockProvider.FilterClosure<N>) {
    self.filter = filter
  }
  
  fileprivate func pass<N: NodeDescription>(_ description: N.Type, props: N.PropsType) -> Bool {
    guard let filter = self.filter as? StateMockProvider.FilterClosure<N> else {
      return false
    }
    
    return filter(props)
  }
}
