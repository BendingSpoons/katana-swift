//
//  Animation.swift
//  Katana
//
//  Created by Mauro Bolis on 26/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public enum Animation {
  case none
  
  // linear
  case linear(duration: TimeInterval)
  case linearWithOptions(duration: TimeInterval,
                          options: UIViewAnimationOptions)
  
  case linearWithDelay(duration: TimeInterval,
               options: UIViewAnimationOptions,
                 delay: TimeInterval)
  
  // spring
  case spring(duration: TimeInterval, damping: CGFloat, initialVelocity: CGFloat)
  
  case springWithOptions(duration: TimeInterval,
                          damping: CGFloat,
                  initialVelocity: CGFloat,
                          options: UIViewAnimationOptions)
  
  case springWithDelay(duration: TimeInterval,
               damping: CGFloat,
       initialVelocity: CGFloat,
               options: UIViewAnimationOptions,
                 delay: TimeInterval)
  
  
  func animateBlock(_ block: @escaping ()->() ) {
    switch self {
    case .none:
      UIView.performWithoutAnimation(block)
     
    case let .linear(duration):
      UIView.animate(withDuration: duration,
                       animations: block)
      
    case let .linearWithOptions(duration, options):
      UIView.animate(withDuration: duration,
                            delay: 0,
                          options: options,
                       animations: block,
                       completion: nil)
      
    case let .linearWithDelay(duration, options, delay):
      UIView.animate(withDuration: duration,
                            delay: delay,
                          options: options,
                       animations: block,
                       completion: nil)
      
    case let .spring(duration, damping, initialVelocity):
      UIView.animate(withDuration: duration,
                            delay: 0,
           usingSpringWithDamping: damping,
            initialSpringVelocity: initialVelocity,
                          options: .curveEaseInOut,
                       animations: block,
                       completion: nil)
      
    case let .springWithOptions(duration, damping, initialVelocity, options):
      UIView.animate(withDuration: duration,
                            delay: 0,
           usingSpringWithDamping: damping,
            initialSpringVelocity: initialVelocity,
                          options: options,
                       animations: block,
                       completion: nil)
      
    case let .springWithDelay(duration, damping, initialVelocity, options, delay):
      UIView.animate(withDuration: duration,
                            delay: delay,
           usingSpringWithDamping: damping,
            initialSpringVelocity: initialVelocity,
                          options: options,
                       animations: block,
                       completion: nil)
    }
  }
}
