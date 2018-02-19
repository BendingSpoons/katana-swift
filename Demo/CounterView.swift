//
//  CounterView.swift
//  Demo
//
//  Created by Mauro Bolis on 19/02/2018.
//

import Foundation
import UIKit

final class CounterView: UIView {
  
  var counterValue = 0 {
    didSet {
      self.update()
    }
  }
  
  private lazy var counterLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.backgroundColor = .mediumAquamarine
    return label
  }()
  
  private lazy var decrementButton: UIButton = {
    let button = UIButton()
    button.setTitle("Decrement", for: .normal)
    button.setTitleColor(.jet, for: .highlighted)
    button.backgroundColor = .dogwoodRose
    
    return button
  }()
  
  private lazy var incrementButton: UIButton = {
    let button = UIButton()
    button.setTitle("Increment", for: .normal)
    button.setTitleColor(.jet, for: .highlighted)
    button.backgroundColor = .japaneseIndigo
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.update()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
    self.update()
  }
  
  // MARK: Setup
  private func setup() {
    self.addSubview(self.counterLabel)
    self.addSubview(self.incrementButton)
    self.addSubview(self.decrementButton)
  }
  
  // MARK: Update
  private func update() {
    self.counterLabel.text = "Counter: \(self.counterValue)"
  }
  
  // MARK: Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.counterLabel.frame = CGRect(
      x: 0,
      y: 0,
      width: self.frame.width,
      height: self.frame.height / 2.0
    )
    
    self.decrementButton.frame = CGRect(
      x: 0,
      y: self.counterLabel.frame.maxY,
      width: self.frame.width / 2.0,
      height: self.frame.height / 2.0
    )
    
    self.incrementButton.frame = CGRect(
      x: self.decrementButton.frame.maxX,
      y: self.counterLabel.frame.maxY,
      width: self.frame.width / 2.0,
      height: self.frame.height / 2.0
    )
  }
}
