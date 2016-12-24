//
//  NativeTouchHandler.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import UIKit

public final class NativeTouchHandler: UIControl {
  var hitTestInsets: UIEdgeInsets = .zero

  var handlers: [TouchHandlerEvent: TouchHandlerClosure]? {
    didSet {
      self.update()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update() {
    self.removeTarget(nil, action: nil, for: .allEvents)

    guard let handlers = self.handlers else { return }

    for (event, _) in handlers {
      if event.contains(.touchDown) {
        self.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
      }

      if event.contains(.touchUpInside) {
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
      }

      if event.contains(.touchUpOutside) {
        self.addTarget(self, action: #selector(didTouchUpOutside), for: .touchUpOutside)
      }

      if event.contains(.touchCancel) {
        self.addTarget(self, action: #selector(didTouchCancel), for: .touchCancel)
      }
    }
  }

  func didTouchDown() {
    self.invokeAllHandlers(for: .touchDown)
  }

  func didTouchUpInside() {
    self.invokeAllHandlers(for: .touchUpInside)
  }

  func didTouchUpOutside() {
    self.invokeAllHandlers(for: .touchUpOutside)
  }

  func didTouchCancel() {
    self.invokeAllHandlers(for: .touchCancel)
  }

  private func invokeAllHandlers(for event: TouchHandlerEvent) {
    guard let handlers = self.handlers else { return }

    let eventHandlers = handlers.filter { $0.key.contains(event) }

    for (_, closure) in eventHandlers {
      closure()
    }
  }

  public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    if self.hitTestInsets == .zero || self.isHidden {
      return super.point(inside: point, with: event)
    }

    let hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.hitTestInsets)
    return hitFrame.contains(point)
  }
}
