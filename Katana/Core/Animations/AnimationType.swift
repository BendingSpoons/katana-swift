//
//  AnimationType.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Enum that represents the animations that can be used to animate an UI update
public enum AnimationType {
  
  /// No animation
  case none
  
  /// Linear animation with a given duration
  case linear(duration: TimeInterval)
  
  /// Linear animation with given duration and options
  case linearWithOptions(duration: TimeInterval,
                          options: UIViewAnimationOptions)
  
  /// Liear animation with given duration, options and delay
  case linearWithDelay(duration: TimeInterval,
               options: UIViewAnimationOptions,
                 delay: TimeInterval)
  
  /// Spring animation with duration, damping and initialVelocity
  case spring(duration: TimeInterval, damping: CGFloat, initialVelocity: CGFloat)
  
  /// Spring animation with duration, damping, initialVelocity and options
  case springWithOptions(duration: TimeInterval,
                          damping: CGFloat,
                  initialVelocity: CGFloat,
                          options: UIViewAnimationOptions)
  
  /// Spring animation with duration, damping, initialVelocity, options and delay
  case springWithDelay(duration: TimeInterval,
               damping: CGFloat,
       initialVelocity: CGFloat,
               options: UIViewAnimationOptions,
                 delay: TimeInterval)
  
  
  /**
   Animates UI changes performed in a block with the animation specified by the enum value
   - parameter block: a block that contains the updates to the UI to animate
  */
  func animate(_ block: @escaping ()->(), completion: (() -> ())? = nil) {
    
    let animationCompletion = { (v: Bool) -> () in
      completion?()
    }
    
    switch self {
    case .none:
      UIView.performWithoutAnimation(block)
      completion?()
     
    case let .linear(duration):
      UIView.animate(withDuration: duration,
                     delay: 0,
                     options: [],
                     animations: block,
                     completion: animationCompletion)
      
    case let .linearWithOptions(duration, options):
      UIView.animate(withDuration: duration,
                            delay: 0,
                          options: options,
                       animations: block,
                       completion: animationCompletion)
      
    case let .linearWithDelay(duration, options, delay):
      UIView.animate(withDuration: duration,
                            delay: delay,
                          options: options,
                       animations: block,
                       completion: animationCompletion)
      
    case let .spring(duration, damping, initialVelocity):
      UIView.animate(withDuration: duration,
                            delay: 0,
           usingSpringWithDamping: damping,
            initialSpringVelocity: initialVelocity,
                          options: .curveEaseInOut,
                       animations: block,
                       completion: animationCompletion)
      
    case let .springWithOptions(duration, damping, initialVelocity, options):
      UIView.animate(withDuration: duration,
                            delay: 0,
           usingSpringWithDamping: damping,
            initialSpringVelocity: initialVelocity,
                          options: options,
                       animations: block,
                       completion: animationCompletion)
      
    case let .springWithDelay(duration, damping, initialVelocity, options, delay):
      UIView.animate(withDuration: duration,
                            delay: delay,
           usingSpringWithDamping: damping,
            initialSpringVelocity: initialVelocity,
                          options: options,
                       animations: block,
                       completion: animationCompletion)
    }
  }
}
