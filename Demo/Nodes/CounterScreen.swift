//
//  CounterScreen.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana
import KatanaElements

struct CounterScreenProps: NodeDescriptionProps, Buildable {
  var frame: CGRect = .zero
  var count: Int = 0
}

struct CounterScreen: ConnectedNodeDescription, PlasticNodeDescription {
  
  enum Keys: String {
    case label
    case incrementButton
    case decrementButton
  }
  
  var props: CounterScreenProps
  
  public static func childrenDescriptions(props: CounterScreenProps,
                                          state: EmptyState,
                                          update: @escaping (EmptyState) -> (),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    return [
      Label(props: LabelProps.build({ (labelProps) in
        labelProps.key = CounterScreen.Keys.label.rawValue
        labelProps.textAlignment = .center
        labelProps.backgroundColor = .mediumAquamarine
        labelProps.text = NSAttributedString(string: "Count: \(props.count)", attributes: nil)
      })),
      Button(props: ButtonProps.build({ (buttonProps) in
        buttonProps.key = CounterScreen.Keys.decrementButton.rawValue
        buttonProps.titles[.normal] = "Decrement"
        buttonProps.backgroundColor = .dogwoodRose
        buttonProps.titleColors = [.highlighted : .red]
        
        buttonProps.touchHandlers = [
          .touchUpInside : {
            dispatch(DecrementCounter())
          }
        ]
      })),
      Button(props: ButtonProps.build({ (buttonProps) in
        buttonProps.key = CounterScreen.Keys.incrementButton.rawValue
        buttonProps.titles[.normal] = "Increment"
        buttonProps.backgroundColor = .japaneseIndigo
        buttonProps.titleColors = [.highlighted : .red]
        
        buttonProps.touchHandlers = [
          .touchUpInside : {
            dispatch(IncrementCounter())
          }
        ]
      }))
    ]
  }
  
  public static func connect(props: inout CounterScreenProps, to storeState: CounterState) {
    props.count = storeState.counter
  }
  
  public static func layout(views: ViewsContainer<CounterScreen.Keys>, props: CounterScreenProps, state: EmptyState) {
    let rootView = views.nativeView
    
    let label = views[.label]!
    let decrementButton = views[.decrementButton]!
    let incrementButton = views[.incrementButton]!
    label.asHeader(rootView)
    [label, decrementButton].fill(top: rootView.top, bottom: rootView.bottom)
    incrementButton.top = decrementButton.top
    incrementButton.bottom = decrementButton.bottom
    [decrementButton, incrementButton].fill(left: rootView.left, right: rootView.right)
  }

  
}


extension UIColor {
  static var mediumAquamarine: UIColor {
    return UIColor (colorLiteralRed: 89.0/255.0, green: 201.0/255.0, blue: 165.0/255.0, alpha: 1.0)
  }
  
  static var dogwoodRose: UIColor {
    return UIColor (colorLiteralRed: 216.0/255.0, green: 30.0/255.0, blue: 91.0/255.0, alpha: 1.0)
  }
  
  static var japaneseIndigo: UIColor {
    return UIColor (colorLiteralRed: 35.0/255.0, green: 57.0/255.0, blue: 91.0/255.0, alpha: 1.0)
  }
}
