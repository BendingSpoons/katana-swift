//
//  AppDelegate.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Cocoa
import Katana_macOS
import KatanaElements_macOS

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  
  struct AppState: State {
  }
  
  @IBOutlet weak var window: NSWindow!
  var renderer: Renderer?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    let view = NSView()
    view.backgroundColor = .red
    window.contentView = view
    let store = Store<AppState>()
    let macViewProps = MacView.Props(alpha: 1.0, frame: CGRect(x: 20, y: 50, width: 300, height: 100), key: "")
    let macView = MacView(props: macViewProps)
    
    
    renderer = Renderer(rootDescription: macView, store: store)
    renderer?.render(in: view)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

