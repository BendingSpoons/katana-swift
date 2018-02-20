//
//  ViewController.swift
//  Demo
//
//  Created by Mauro Bolis on 19/02/2018.
//  Copyright © 2018 Mauro Bolis. All rights reserved.
//

import UIKit
import Katana

class CounterViewController: UIViewController {
  unowned let store: Store<AppState>
  var storeUnsubscribe: StoreUnsubscribe?
  
  init(store: Store<AppState>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)
    self.listenStore()
    self.addInteractions()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("This init is not implemented")
  }
  
  override func loadView() {
    self.view = CounterView()
  }
  
  deinit {
    self.storeUnsubscribe?()
  }
  
  // MARK: Private
  private func addInteractions() {
    guard let view = self.view as? CounterView else {
      return
    }
    
    view.userDidTapIncrementButton = { [weak self] in
      self?.store.dispatch(IncrementCounter())
    }
    
    view.userDidTapDecrementButton = { [weak self] in
      self?.store.dispatch(DecrementCounter())
    }
  }
  
  
  private func listenStore() {
    self.storeUnsubscribe = self.store.addListener { [weak self] in
      self?.storeDidChange()
    }
  }
  
  private func storeDidChange() {
    guard let view = self.view as? CounterView else {
      return
    }
    
    let counterValue = self.store.state.counter
    view.counterValue = counterValue
  }
}

