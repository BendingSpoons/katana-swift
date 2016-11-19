//
//  AppDelegate.swift
//  Demo mac
//
//  Created by Andrea De Angelis on 18/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Cocoa
import Katana

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
    let macViewProps = MacView.Props(alpha: 1.0, frame: CGRect(x: 20, y: 50, width: 100, height: 100), key: "")
    let macView = MacView(props: macViewProps)
    renderer = Renderer(rootDescription: macView, store: store)
    renderer?.render(in: view)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

