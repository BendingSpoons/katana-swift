//
//  StateMockProvider.swift
//  Katana
//
//  Created by Mauro Bolis on 02/04/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation

/**
 `StateMockProvider` is a class that can be used to mock the internal state of the descriptions
 for testing purposes.
 
 The basic idea is that the class encaspulates the possible mocks that are defined for a certain test case.
 State mocks are defined in relation to a Description type and a filter. When the UI is rendered, and a
 mock state provider is provided, Katana asks to the provider if there is a mocked state for the description
 it is managing given the props the description has. If there is a mocked state, this state overrides the state.
 
 It is important to note that this mechanism basically inhibits the `update` method in the descriptions.
 
 - warning: it is important to remember that order matters. If two mocked state are available for the same context
 (that is, description and props), the first will be used.
 
 ### Usage
 ```swift
 let mock = StateMockProvider()
 
 mock.mockState(ADescription.State(), for: ADescription.Type, passingFilter: { props in
 // return true or false based on the props
 })
 
 let renderer = Renderer(rootDescription: description, store: store, stateMockProvider: mock)
 ```
*/
public class StateMockProvider {
  
  /**
   Closure that is used check whether a mocked state should be applied for a description
   that has some properties
   
   - parameter props: the props of the description
   - returns: whether the associated state should be applied or not
  */
  public typealias FilterClosure<N: NodeDescription> = (_ props: N.PropsType) -> Bool
  
  /// The mocks that are defined
  fileprivate var mocks: [String: [(filter: AnyFilterClosure, state: Any)]]

  /// Creates a new mock provider
  public init() {
    self.mocks = [:]
  }

  /**
   Add a new mocked state
   
   - parameter mockedState: the state to mock
   - parameter descriptionType: the description type to which the state will be applied to
   - parameter filter: a closure that is used to check whether a state should be applied to a 
                       specific description with props or not
  */
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
  
  /**
   Retrieves a mocked state, if any, for a description with the given props
   
   - parameter descriptionType: the type of the description
   - parameter props: the props of the description
   - returns: the mocked state, if any
  */
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

/// Struct used to type erase the FilterClosure
fileprivate struct AnyFilterClosure {
  
  /// The filter closure
  private let filter: Any
  
  /**
   Creates a new type erasure for the closure
   - parameter descriptionType: the type of the description for the filter
   - parameter filter: the filter to type-erase

   - warning: `descriptionType` shouldn't be necessary. Unfortunately the swift compiler fails to compile
              because it is not able to infer the generic type without this parameter
  */
  init<N: NodeDescription>(_ descriptionType: N.Type, filter: @escaping StateMockProvider.FilterClosure<N>) {
    self.filter = filter
  }

  /**
   Returns whether the erased filter passes with the given props. Note that if the filter is not
   compatbile with the given description type, then the method will return false
   - parameter descriptionType: the type of the description for the filter
   - parameter props: the props that will be passed to the filter
   - returns: whether the filter passes or not
   
   - warning: `descriptionType` shouldn't be necessary. Unfortunately the swift compiler fails to compile
   because it is not able to infer the generic type without this parameter
  */
  fileprivate func pass<N: NodeDescription>(_ descriptionType: N.Type, props: N.PropsType) -> Bool {
    guard let filter = self.filter as? StateMockProvider.FilterClosure<N> else {
      return false
    }
    
    return filter(props)
  }
}
