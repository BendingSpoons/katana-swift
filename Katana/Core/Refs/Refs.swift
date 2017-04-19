//
//  Refs.swift
//  Katana
//
//  Created by Mauro Bolis on 19/04/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation

/// Closure used to provide the ref in node descriptions that implement the `NodeDescriptionWithRef` protocol
public typealias RefCallbackClosure<Ref:  NativeViewRef> = (_ ref: Ref) -> Void

/// Type erasure for `RefCallbackClosure`
public typealias AnyRefCallbackClosure = (_ anyRef: Any) -> Void

/// Type erasure for `NodeDescriptionWithRefProps`
public protocol AnyNodeDescriptionWithRefProps: AnyNodeDescriptionProps {
  
  /// Type erasure for `refCallback` in `NodeDescriptionWithRefProps`
  var anyRefCallback: AnyRefCallbackClosure? { get }
}

/// Props type for node descriptions that implement the `NodeDescriptionWithRefProps` protocol
public protocol NodeDescriptionWithRefProps: NodeDescriptionProps, AnyNodeDescriptionWithRefProps {
  
  /// The ref type that is associated with the node description
  associatedtype RefType: NativeViewRef

  /**
   A closure that is invoked when the ref is ready to be used. The exact moment when it
   happens is an implementation detail and should not be leveraged to implement features or
   behaviours. The idea is that the provided ref should be saved and used to implement imperative
   behaviours
  */
  var refCallback: RefCallbackClosure<RefType>? { get }
}

/// Default implementation of the `AnyNodeDescriptionWithRefProps` protocol
public extension NodeDescriptionWithRefProps {
  
  /// The default implementation invokes `refCallback` with the correct type
  var anyRefCallback: AnyRefCallbackClosure? {
    guard let refClosure = self.refCallback else {
      return nil
    }
    
    return { refValue in
      // we want a crash here because it means there is something wrong
      // in the description implementation. Fail silently here could lead to
      // situations where is hard to debug the issue
      let typedRefValue = refValue as! RefType
      refClosure(typedRefValue)
    }
  }
}

/**
 Node Descriptions can implement this protocol to provide a way to access to imperative behaviours.
 
 There are two cases where this could be leveraged:
 - updating the state/storage too often leads to performance issues. Refs could be used
   to temporary skip the classic update cycle and improve the performances
 
 - trigger imperative behaviours which would be hard/weird to implement with a declarative approach.
   For instance, "dismiss/show keyboard" is a good example of imperative behaviour
 
 In general refs, should be used as last resort. Declarative way is more appropriated in Katana and
 in it is safer.
*/
public protocol NodeDescriptionWithRef: NodeDescription {
  
  /// Extra constrains for the native view
  associatedtype NativeView: NativeViewWithRef
  
  /// Extra constrains for the props
  associatedtype PropsType: NodeDescriptionWithRefProps
}

/// Type erasure for `NativeViewWithRef`
public protocol AnyPlatformNativeViewWithRef {
  
  /// Type erasure for `ref` in `NativeViewWithRef`
  var anyRef: Any { get }
}

/**
 Protocol for native views of descriptions that implement the `NodeDescriptionWithRef` protocol.
 NativeViews should provide the ref values.
*/
public protocol NativeViewWithRef: PlatformNativeView, AnyPlatformNativeViewWithRef {
  
  /// The ref type that is returned
  associatedtype RefType: NativeViewRef
  
  /// The ref instance of the native view
  var ref: RefType { get }
}

/// Implementation of the `AnyNativeViewWithRef` protocol
public extension NativeViewWithRef {
  
  /// The default implementation returns `ref`
  var anyRef: Any {
    return self.ref
  }
}

/**
 Protocol for refs.
 
 A ref is nothing more that a proxy to the native view.
 It is used for two reasons:
  - limit the exposed properties/methods
  - avoid retain cycles
 
 The second reason also requires a special attention during the implementation.
 
 In particular, the idea is that the ref should contain a weak reference to the native view.
 The init should be therefore implemented in the following way:
 
 ```swift
 init(nativeView: NativeTextField) {
  weak var s: NativeViewType? = nativeView
  self.nativeView = s
 }
 ```
 
 where `nativeView` is a weak variable
 
 ```swift
 private weak var nativeView: NativeViewType?
 ```
 
 Failing in implement the ref in the proper way could lead to wrong behaviours, memory leaks and so on.
 
 - seeAlso: `NodeDescriptionWithRef`
*/
public protocol NativeViewRef {
  associatedtype NativeViewType: PlatformNativeView
  
  init(nativeView: NativeViewType)
  
  var isValid: Bool { get }
}
