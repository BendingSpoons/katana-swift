//
//  AppDelegate.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Cocoa
import Katana
import KatanaElements

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  var renderer: Renderer?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let view = NSView()
    window.contentView = view
    window.delegate = self

    let store = Store<CounterState>()
    let screen = CounterScreen(props: CounterScreen.Props.build({
      $0.frame = view.bounds
    }))

    renderer = Renderer(rootDescription: screen, store: store)
    renderer?.render(in: view)
  }

}

extension AppDelegate: NSWindowDelegate {
  public func windowDidResize(_ notification: Notification) {
    let newProps = CounterScreen.Props.build({
      $0.frame = window.contentView?.bounds ?? .zero
    })
    let description = CounterScreen(props: newProps)
    renderer?.rootNode.update(with: description)
  }
}
