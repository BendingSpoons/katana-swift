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

public struct AnimationOptions: OptionSet {
  public let rawValue: UInt

  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }

  static let layoutSubview = AnimationOptions(rawValue: 1 << 0)
  static let allowUserInteraction = AnimationOptions(rawValue: 1 << 1)
  static let beginFromCurrentState = AnimationOptions(rawValue: 1 << 2)
  static let repeatAnimation = AnimationOptions(rawValue: 1 << 3)
  static let autoreverse = AnimationOptions(rawValue: 1 << 4)
  static let overrideInheritedDuration = AnimationOptions(rawValue: 1 << 5)
  static let overrideInheritedCurve = AnimationOptions(rawValue: 1 << 6)
  static let allowAnimatedContent = AnimationOptions(rawValue: 1 << 7)
  static let showHideTransitionViews = AnimationOptions(rawValue: 1 << 8)
  static let overrideInheritedOptions = AnimationOptions(rawValue: 1 << 9)

  static let curveEaseInOut = AnimationOptions(rawValue: 0 << 16)
  static let curveEaseIn = AnimationOptions(rawValue: 1 << 16)
  static let curveEaseOut = AnimationOptions(rawValue: 2 << 16)
  static let curveLinear = AnimationOptions(rawValue: 3 << 16)

  static let transitionNone = AnimationOptions(rawValue: 0 << 20)
  static let transitionFlipFromLeft = AnimationOptions(rawValue: 1 << 20)
  static let transitionFlipFromRight = AnimationOptions(rawValue: 2 << 20)
  static let transitionCurlUp = AnimationOptions(rawValue: 3 << 20)
  static let transitionCurlDown = AnimationOptions(rawValue: 4 << 20)
  static let transitionCrossDissolve = AnimationOptions(rawValue: 5 << 20)
  static let transitionFlipFromTop = AnimationOptions(rawValue: 6 << 20)
  static let transitionFlipFromBottom = AnimationOptions(rawValue: 7 << 20)
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
