//
//  AnimationType.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import CoreGraphics
//import UIKit

/**
  A set of options that can be used to personalise the animations
*/
public struct AnimationOptions: OptionSet {
  /// The raw value of the OptionSet
  public let rawValue: UInt

  /**
    Creates a new AnimationOptions instance. Always prefer
    the static values instead of creating a new instance directly
   
    - parameter rawValue: the raw value of the option
    - returns: an instance of AnimationOptions
  */
  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }
  
  /// Lay out subviews at commit time so that they are animated along with their parent.
  public static let layoutSubview = AnimationOptions(rawValue: 1 << 0)
  
  /// Allow the user to interact with views while they are being animated.
  public static let allowUserInteraction = AnimationOptions(rawValue: 1 << 1)
  
  /**
   Start the animation from the current setting associated with an already in-flight animation.
   If this key is not present, any in-flight animations are allowed to finish
   before the new animation is started. If another animation is not in flight, this key has no effect.
  */
  public static let beginFromCurrentState = AnimationOptions(rawValue: 1 << 2)
  
  /// Repeat the animation indefinitely.
  public static let repeatAnimation = AnimationOptions(rawValue: 1 << 3)
  
  /// Run the animation backwards and forwards. Must be combined with the `repeatAnimation` option.
  public static let autoreverse = AnimationOptions(rawValue: 1 << 4)
  
  /**
   Force the animation to use the original duration value specified when the
   animation was submitted. If this key is not present, the animation inherits the
   remaining duration of the in-flight animation, if any.
  */
  public static let overrideInheritedDuration = AnimationOptions(rawValue: 1 << 5)
  
  /**
   Force the animation to use the original curve value specified when the animation
   was submitted. If this key is not present, the animation inherits the curve
   of the in-flight animation, if any.
  */
  public static let overrideInheritedCurve = AnimationOptions(rawValue: 1 << 6)
  
  /**
   Animate the views by changing the property values dynamically and redrawing the view.
   If this key is not present, the views are animated using a snapshot image.
  */
  public static let allowAnimatedContent = AnimationOptions(rawValue: 1 << 7)
  
  /**
   When present, this key causes views to be hidden or shown (instead of removed or added)
   when performing a view transition. Both views must already be present in the
   parent view’s hierarchy when using this key. If this key is not present,
   the to-view in a transition is added to, and the from-view is removed from,
   the parent view’s list of subviews.
  */
  public static let showHideTransitionViews = AnimationOptions(rawValue: 1 << 8)
  
  /// The option to not inherit the animation type or any options.
  public static let overrideInheritedOptions = AnimationOptions(rawValue: 1 << 9)
  
  /**
   An ease-in ease-out curve causes the animation to begin slowly, accelerate
   through the middle of its duration, and then slow again before
   completing.
  */
  public static let curveEaseInOut = AnimationOptions(rawValue: 0 << 16)
  
  /// An ease-in curve causes the animation to begin slowly, and then speed up as it progresses.
  public static let curveEaseIn = AnimationOptions(rawValue: 1 << 16)
  
  /// An ease-out curve causes the animation to begin quickly, and then slow as it completes.
  public static let curveEaseOut = AnimationOptions(rawValue: 2 << 16)
  
  /// A linear animation curve causes an animation to occur evenly over its duration.
  public static let curveLinear = AnimationOptions(rawValue: 3 << 16)
  
  /// No transition is specified.
  public static let transitionNone = AnimationOptions(rawValue: 0 << 20)
  
  /**
   A transition that flips a view around its vertical axis from left to right.
   The left side of the view moves toward the front and right side toward the back.
  */
  public static let transitionFlipFromLeft = AnimationOptions(rawValue: 1 << 20)
  
  /**
   A transition that flips a view around its vertical axis from right to left.
   The right side of the view moves toward the front and left side toward the back.
  */
  public static let transitionFlipFromRight = AnimationOptions(rawValue: 2 << 20)
  
  /// A transition that curls a view up from the bottom.
  public static let transitionCurlUp = AnimationOptions(rawValue: 3 << 20)
  
  /// A transition that curls a view down from the top.
  public static let transitionCurlDown = AnimationOptions(rawValue: 4 << 20)
  
  /// A transition that dissolves from one view to the next.
  public static let transitionCrossDissolve = AnimationOptions(rawValue: 5 << 20)
  
  /**
   A transition that flips a view around its horizontal axis from top to bottom.
   The top side of the view moves toward the front and the bottom side toward the back.
  */
  public static let transitionFlipFromTop = AnimationOptions(rawValue: 6 << 20)
  
  /**
    A transition that flips a view around its horizontal axis from bottom to top.
   The bottom side of the view moves toward the front and the top side toward the back.
  */
  public static let transitionFlipFromBottom = AnimationOptions(rawValue: 7 << 20)
}

/// Enum that represents the animations that can be used to animate an UI update
public enum AnimationType {

  /// No animation
  case none

  /// Linear animation with a given duration
  case linear(duration: TimeInterval)

  /// Linear animation with given duration and options
  case linearWithOptions(duration: TimeInterval,
                          options: AnimationOptions)

  /// Liear animation with given duration, options and delay
  case linearWithDelay(duration: TimeInterval,
               options: AnimationOptions,
                 delay: TimeInterval)

  /// Spring animation with duration, damping and initialVelocity
  case spring(duration: TimeInterval, damping: CGFloat, initialVelocity: CGFloat)

  /// Spring animation with duration, damping, initialVelocity and options
  case springWithOptions(duration: TimeInterval,
                          damping: CGFloat,
                  initialVelocity: CGFloat,
                          options: AnimationOptions)

  /// Spring animation with duration, damping, initialVelocity, options and delay
  case springWithDelay(duration: TimeInterval,
               damping: CGFloat,
       initialVelocity: CGFloat,
               options: AnimationOptions,
                 delay: TimeInterval)

}
