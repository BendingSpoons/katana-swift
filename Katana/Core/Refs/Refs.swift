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

public protocol AnyNodeDescriptionWithRefProps: AnyNodeDescriptionProps {
  var anyRefCallback: AnyRefCallbackClosure? { get }
}

public protocol NodeDescriptionWithRefProps: NodeDescriptionProps, AnyNodeDescriptionWithRefProps {
  associatedtype RefType: NativeViewRef

  var refCallback: RefCallbackClosure<RefType>? { get }
}

public extension NodeDescriptionWithRefProps {
  var anyRefCallback: AnyRefCallbackClosure? {
    guard let refClosure = self.refCallback else {
      return nil
    }
    
    return { refValue in
      // we want a crash here because it means there is something wrong
      // in the element implementation. Fail silently here could lead to
      // situations where is hard to debug the issue
      let typedRefValue = refValue as! RefType
      refClosure(typedRefValue)
    }
  }
}


public protocol NodeDescriptionWithRef: NodeDescription {
  // add some constraints to the NativeView
  associatedtype NativeView: NativeViewWithRef
    
  associatedtype PropsType: NodeDescriptionWithRefProps
}

public protocol AnyPlatformNativeViewWithRef {
  var anyRef: Any { get }
}

public protocol NativeViewWithRef: PlatformNativeView, AnyPlatformNativeViewWithRef {
  associatedtype RefType: NativeViewRef
  
  var ref: RefType { get }
}

public extension NativeViewWithRef {
  var anyRef: Any {
    return self.ref
  }
}

public protocol NativeViewRef {
  associatedtype NativeViewType: PlatformNativeView
  
  init(nativeView: NativeViewType)
  
  var isValid: Bool { get }
}
