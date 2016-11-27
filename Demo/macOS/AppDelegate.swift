//
//  Button.swift
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

  struct AppState: State {}

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
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

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

}

extension AppDelegate: NSWindowDelegate {
  public func windowDidResize(_ notification: Notification) {
    let props = CounterScreen.Props.build({
      $0.frame = window.contentView?.bounds ?? .zero
    })
    let description = CounterScreen(props: props)
    renderer?.rootNode.update(with: description)
    /*renderer?.rootNode.update(with: MacScreen.Props.build({
      $0.frame = window.contentView?.bounds ?? .zero
    }))*/
  }
}
