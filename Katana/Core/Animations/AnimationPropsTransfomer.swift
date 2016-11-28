//
//  AnimationPropsTransfomer.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import CoreGraphics

/**
 The transformer function used to update properties to perform entry and leave animations.
 The idea is that props are changed by chaining different transformers.
 */
public typealias AnimationPropsTransformer = (_ props: AnyNodeDescriptionProps) -> AnyNodeDescriptionProps

/// Built in implementations of `AnimationPropsTransformer`
public struct AnimationProps {
  private init() {}
  
  /**
   Scales the size of the element
   
   - parameter percentage: value used to define how much the element is scaled
   - returns: an `AnimationPropsTransformer` that scales the size of the element
  */
  public static func scale(percentage: CGFloat) -> AnimationPropsTransformer {
    return {
      var p = $0
      
      p.frame.size = CGSize(
        width: $0.frame.size.width * percentage,
        height: $0.frame.size.height * percentage
      )
      
      p.frame.origin = CGPoint(
        x: $0.frame.origin.x + $0.frame.size.width / 2.0,
        y: $0.frame.origin.y + $0.frame.size.height / 2.0
      )
      
      return p
    }
  }
  
  /**
   Moves the element to the left
   
   - parameter distance: the amount of points by which the element is moved. Given an animation duration,
                         the grater is the distance, the faster the element is in moving to the final position
   
   - returns: an `AnimationPropsTransformer` that moves the element
  */
  public static func moveLeft(distance: CGFloat = 1000) -> AnimationPropsTransformer {
    return {
      var p = $0
      p.frame.origin.x = p.frame.origin.x - distance
      return p
    }
  }

  /**
   Moves the element to the right
   
   - parameter distance: the amount of points by which the element is moved. Given an animation duration,
                         the grater is the distance, the faster the element is in moving to the final position
   
   - returns: an `AnimationPropsTransformer` that moves the element
  */
  public static func moveRight(distance: CGFloat = 1000) -> AnimationPropsTransformer {
    return {
      var p = $0
      p.frame.origin.x = p.frame.origin.x + distance
      return p
    }
  }
  
  /**
   Fades the element. If uses in the `entry` context, the result is a `fade in` animation. When used
   in a `leave` context, the result is a `fade out` animation.
   
   - returns: an `AnimationPropsTransformer` that fades the element
  */
  public static func fade() -> AnimationPropsTransformer {
    return {
      var p = $0
      p.alpha = 0.0
      return p
    }
  }
}
