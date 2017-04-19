//
//  Refs.swift
//  Katana
//
//  Created by Mauro Bolis on 19/04/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation

public typealias RefCallbackClosure<Ref:  NativeViewRef> = (_ ref: Ref) -> Void
public typealias AnyRefCallbackClosure = (_ anyRef: Any) -> Void

public protocol AnyNodeDescriptionWithRef: AnyNodeDescription {
  var anyRefCallback: AnyRefCallbackClosure? { get }
}

public protocol NodeDescriptionWithRef: NodeDescription, AnyNodeDescriptionWithRef {

  // add some constraints to the NativeView
  associatedtype NativeView: PlatformNativeViewWithRef
  
  var refCallback: RefCallbackClosure<NativeView.RefType>? { get }
}

public extension NodeDescriptionWithRef {
  var anyRefProvider: AnyRefCallbackClosure? {
    guard let refClosure = self.refCallback else {
      return nil
    }
    
    return { refValue in
      // we want a crash here because it means there is something wrong
      // in the element implementation. Fail silently here could lead to
      // situations where is hard to debug the issue
      let typedRefValue = refValue as! NativeView.RefType
      refClosure(typedRefValue)
    }
  }
}

public protocol AnyPlatformNativeViewWithRef {
  var anyRef: Any { get }
}

public protocol PlatformNativeViewWithRef: PlatformNativeView {
  associatedtype RefType: NativeViewRef
  
  var ref: RefType { get }
}

public extension PlatformNativeViewWithRef {
  var anyRef: Any {
    return self.ref
  }
}

public protocol NativeViewRef {
  associatedtype NativeView: PlatformNativeView
  
  init(nativeView: NativeView)
  
  var isValid: Bool { get }
}
