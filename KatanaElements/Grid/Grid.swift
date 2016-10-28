//
//  Grid.swift
//  Katana
//
//  Created by Mauro Bolis on 23/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit
import Katana

public struct GridProps: NodeProps, Keyable {
  public var frame = CGRect.zero
  public var key: String?
  public var delegate: GridDelegate?
  
  public var cellAspectRatio: CGFloat?
  public var numberOfCellsOnline: Int?
  public var minimumCellLenghtOnline: Value?
  public var sectionInsets: EdgeInsets?
  public var lineInsets: Value?
  public var cellSpacing: Value?
  
  public init() {}
  
  public func delegate(_ delegate: GridDelegate) -> GridProps {
    var copy = self
    copy.delegate = delegate
    return copy
  }
  
  public func cellAspectRatio(_ cellAspectRatio: CGFloat) -> GridProps {
    var copy = self
    copy.cellAspectRatio = cellAspectRatio
    return copy
  }

  public func numberOfCellsOnline(_ numberOfCellsOnline: Int) -> GridProps {
    var copy = self
    copy.numberOfCellsOnline = numberOfCellsOnline
    return copy
  }

  public func minimumCellLenghtOnline(_ minimumCellLenghtOnline: Value) -> GridProps {
    var copy = self
    copy.minimumCellLenghtOnline = minimumCellLenghtOnline
    return copy
  }
  
  public func sectionInsets(_ sectionInsets: EdgeInsets) -> GridProps {
    var copy = self
    copy.sectionInsets = sectionInsets
    return copy
  }
  
  public func lineInsets(_ lineInsets: Value) -> GridProps {
    var copy = self
    copy.lineInsets = lineInsets
    return copy
  }
  
  public func cellSpacing(_ cellSpacing: Value) -> GridProps {
    var copy = self
    copy.cellSpacing = cellSpacing
    return copy
  }
  
  public static func == (lhs: GridProps, rhs: GridProps) -> Bool {
    // delegate to the grid mechanism any optimization here
    return false
  }
}


public struct Grid: NodeDescription {
  public typealias NativeView = NativeGridView
  
  public var props: GridProps
  
  public init(props: GridProps) {
    self.props = props
  }
  
  public static func applyPropsToNativeView(props: GridProps,
                                            state: EmptyState,
                                            view: NativeGridView,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    
    let delegate = props.delegate ?? EmptyGridDelegate()
    
    view.frame = props.frame
    view.update(withParent: node, delegate: delegate, props: props)
  }
  
  
  public static func childrenDescriptions(props: GridProps,
                            state: EmptyState,
                            update: @escaping (EmptyState)->(),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
}
