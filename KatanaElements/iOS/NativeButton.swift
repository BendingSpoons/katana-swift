//
//  NativeButton.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public class NativeButton: UIButton {

  public typealias ButtonEvent = (NativeButton) -> ()
  
  public var touchHandlers: [TouchHandlerEvent: TouchHandlerClosure] = [:] {
    didSet {
      updateTargets()
    }
  }
  
  private func updateTargets() {
    self.didTouchUpInside = touchHandlers[.touchUpInside]
    self.didTouchDown = touchHandlers[.touchDown]
    self.didTouchUpOutside = touchHandlers[.touchUpOutside]
    self.didTouchCancel = touchHandlers[.touchCancel]
  }
  
  public var didTouchUpInside: TouchHandlerClosure? {
    didSet {
      if didTouchUpInside != nil {
        addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
      } else {
        removeTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
      }
    }
  }
  
  public var didTouchDown: TouchHandlerClosure? {
    didSet {
      if didTouchDown != nil {
        addTarget(self, action: #selector(didTouchDown(sender:)), for: .touchDown)
      } else {
        removeTarget(self, action: #selector(didTouchDown(sender:)), for: .touchDown)
      }
    }
  }
  
  public var didTouchUpOutside: TouchHandlerClosure? {
    didSet {
      if didTouchUpOutside != nil {
        addTarget(self, action: #selector(didTouchUpOutside(sender:)), for: .touchUpOutside)
      } else {
        removeTarget(self, action: #selector(didTouchUpOutside(sender:)), for: .touchUpOutside)
      }
    }
  }
  
  public var didTouchCancel: TouchHandlerClosure? {
    didSet {
      if didTouchCancel != nil {
        addTarget(self, action: #selector(didTouchCancel(sender:)), for: .touchCancel)
      } else {
        removeTarget(self, action: #selector(didTouchCancel(sender:)), for: .touchCancel)
      }
    }
  }
  
  // MARK: - Actions
  @objc private func didTouchUpInside(sender: NativeButton) {
    if let handler = didTouchUpInside {
      handler()
    }
  }

  @objc private func didTouchDown(sender: NativeButton) {
    if let handler = didTouchDown {
      handler()
    }
  }
  
  @objc private func didTouchCancel(sender: NativeButton) {
    if let handler = didTouchCancel {
      handler()
    }
  }
  
  @objc private func didTouchUpOutside(sender: NativeButton) {
    if let handler = didTouchUpOutside {
      handler()
    }
  }
}
