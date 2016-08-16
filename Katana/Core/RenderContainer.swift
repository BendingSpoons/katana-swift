//
//  RenderContainer.swift
//  Katana
//
//  Created by Luca Querella on 07/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol RenderContainerChild {}

public protocol RenderContainer {
  
  func removeAll()
  
  func add(child: () -> UIView) -> RenderContainer
  
  func update(view: (UIView)->())
  
  func children () -> [RenderContainerChild]
  
  func bringToFront(child: RenderContainerChild)
  
  func remove(child: RenderContainerChild)
}

public class RenderContainers : RenderContainer {
  
  private let containers : [RenderContainer]
  private var containerChildren : [RenderContainers] = []
  
  public struct OpaqueChild : RenderContainerChild {
    private let child : RenderContainers
    private let containerChildren : [RenderContainerChild]
  }
  
  public init(containers: [RenderContainer]) {
    self.containers = containers
  }
  
  public func removeAll() {
    self.containerChildren = []
    self.containers.forEach { $0.removeAll() }
  }
  
  public func add(child: () -> UIView) -> RenderContainer {
    let result = RenderContainers(containers: self.containers.map { $0.add(child: child) })
    self.containerChildren.append(result)
    return result
  }
  
  public func update(view: (UIView) -> ()) {
    self.containers.forEach { $0.update(view: view) }
  }
  
  public func children() -> [RenderContainerChild] {
    
    let containersChildren = self.containers.map {$0.children()}
    return self.containerChildren.enumerated().map { (index,element)  in
      return OpaqueChild(child: element, containerChildren: containersChildren.map { $0[index] })
    }
  }
  
  public func bringToFront(child: RenderContainerChild) {
    
    let child = (child as! OpaqueChild)
    
    self.containers.enumerated().forEach{ (index,element) in
      element.bringToFront(child: child.containerChildren[index])
    }
    let index  = self.containerChildren.index { $0 === child.child }
    self.containerChildren.remove(at: index!)
    self.containerChildren.insert(child.child, at: 0)
  }
  
  public func remove(child: RenderContainerChild) {
    let child = (child as! OpaqueChild)
    
    
    self.containers.enumerated().forEach{ (index,element) in
      element.remove(child: child.containerChildren[index])
    }
    
    let index  = self.containerChildren.index { $0 === child.child }
    self.containerChildren.remove(at: index!)
  }
}


public class RenderProfiler : RenderContainer {
  
  private let handler : ((Actions)-> ())?
  private var profilerChildren : [RenderProfiler] = []
  private var root : RenderProfiler?
  private(set) public var actions = Actions(updates: 0, adds: 0, lists: 0, moves: 0, deletes: 0) {
    didSet {
      self.handler?(actions)
    }
  }
  
  public struct Actions {
    public var updates = 0
    public var adds = 0
    public var lists = 0
    public var moves = 0
    public var deletes = 0
  }
  
  public init(_ handler: ((Actions)->())? ) {
    self.handler = handler
  }
  
  public struct OpaqueChild : RenderContainerChild {
    private var child : RenderProfiler
  }
  
  public func removeAll() {
    (self.root ?? self ).actions.deletes += self.profilerChildren.count
    (self.root ?? self ).actions.lists += 1
    self.profilerChildren = []
  }
  
  public func add(child: () -> UIView) -> RenderContainer {
    let result = RenderProfiler(nil)
    result.root = self.root ?? self
    profilerChildren.append(result)
    (self.root ?? self ).actions.adds += 1
    return result
  }
  
  public func update(view: (UIView) -> ()) {
    (self.root ?? self ).actions.updates += 1
  }
  
  public func children() -> [RenderContainerChild] {
    (self.root ?? self ).actions.lists += 1
    return self.profilerChildren.map { OpaqueChild(child: $0) }
  }
  
  public func bringToFront(child: RenderContainerChild) {
    (self.root ?? self ).actions.moves += 1
    
    let child = (child as! OpaqueChild).child
    let index  = self.profilerChildren.index { $0 === child }
    self.profilerChildren.remove(at: index!)
    self.profilerChildren.insert(child, at: 0)
    (self.root ?? self ).actions.moves += 1
    
  }
  
  public func remove(child: RenderContainerChild) {
    let child = (child as! OpaqueChild).child
    let index  = self.profilerChildren.index { $0 === child }
    self.profilerChildren.remove(at: index!)
    (self.root ?? self ).actions.deletes += 1
  }
}

private let VIEW_TAG = 999987

extension UIView : RenderContainer {
  public struct UIViewRenderContainerChild : RenderContainerChild {
    private var view : UIView
  }
  
  public func removeAll() {
    self.subviews
      .filter { $0.tag == VIEW_TAG }
      .forEach { $0.removeFromSuperview() }
  }
  
  public func add(child: () -> UIView) -> RenderContainer {
    let child = child()
    child.tag = VIEW_TAG
    self.addSubview(child)
    return child
  }
  
  public func update(view: (UIView)->()) {
    view(self)
  }
  
  public func children () -> [RenderContainerChild] {
    return self.subviews.filter {$0.tag == VIEW_TAG}.map { UIViewRenderContainerChild(view: $0) }
  }
  
  public func bringToFront(child: RenderContainerChild) {
    let child = child as! UIViewRenderContainerChild
    self.bringSubview(toFront: child.view)
  }
  
  public func remove(child: RenderContainerChild) {
    let child = child as! UIViewRenderContainerChild
    child.view.removeFromSuperview()
  }
}
