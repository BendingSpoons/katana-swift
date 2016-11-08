//
//  Animation.swift
//  Katana
//
//  Created by Mauro Bolis on 08/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public typealias AnimationPropsTransformer = (_ props: AnyNodeProps) -> AnyNodeProps

public struct Animation {
  let type: AnimationType
  let entryTransformers: [AnimationPropsTransformer]
  let leaveTransformers: [AnimationPropsTransformer]
  
  static let none = Animation(type: .none)
  
  public init(type: AnimationType, entryTransformers: [AnimationPropsTransformer], leaveTransformers: [AnimationPropsTransformer]) {
    self.type = type
    self.entryTransformers = entryTransformers
    self.leaveTransformers = leaveTransformers
  }
  
  public init(type: AnimationType) {
    self.type = type
    self.entryTransformers = []
    self.leaveTransformers = []
  }
}
