//
//  CounterScreen.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana
import KatanaElements

extension CounterScreen {
  enum Keys {
    case label
    case incrementButton
    case decrementButton
  }

  struct Props: NodeDescriptionProps, Buildable {
    var alpha: CGFloat = 1.0
    var frame: CGRect = .zero
    var key: String?

    var count: Int = 0
  }
}

struct CounterScreen: ConnectedNodeDescription, PlasticNodeDescription, PlasticReferenceSizeable {
  typealias StateType = EmptyState
  typealias PropsType = Props
  typealias NativeView = UIView

  var props: PropsType

  static var referenceSize = CGSize(width: 640, height: 960)

  public static func childrenDescriptions(props: PropsType,
                                          state: StateType,
                                          update: @escaping (StateType) -> (),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {

    return [
      Label(props: Label.Props.build({
        $0.setKey(Keys.label)
        $0.textAlignment = .center
        $0.backgroundColor = .mediumAquamarine
        $0.text = NSAttributedString(string: "Count: \(props.count)")
      })),
      Button(props: Button.Props.build({
        $0.setKey(Keys.decrementButton)
        $0.titles[.normal] = "Decrement"
        $0.backgroundColor = .dogwoodRose
        $0.titleColors = [.highlighted: .jet]

        $0.touchHandlers = [
          .touchUpInside: {
            dispatch(DecrementCounter())
          }
        ]
      })),
      Button(props: Button.Props.build({
        $0.setKey(Keys.incrementButton)
        $0.titles[.normal] = "Increment"
        $0.backgroundColor = .japaneseIndigo
        $0.titleColors = [.highlighted: .jet]

        $0.touchHandlers = [
          .touchUpInside: {
            dispatch(IncrementCounter())
          }
        ]
      }))
    ]
  }

  public static func connect(props: inout PropsType, to storeState: CounterState) {
    props.count = storeState.counter
  }

  public static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) {
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
    return UIColor(red: 89.0/255.0, green: 201.0/255.0, blue: 165.0/255.0, alpha: 1.0)
  }

  static var dogwoodRose: UIColor {
    return UIColor(red: 216.0/255.0, green: 30.0/255.0, blue: 91.0/255.0, alpha: 1.0)
  }

  static var japaneseIndigo: UIColor {
    return UIColor(red: 35.0/255.0, green: 57.0/255.0, blue: 91.0/255.0, alpha: 1.0)
  }

  static var jet: UIColor {
    return UIColor(red: 51.0/255.0, green: 49.0/255.0, blue: 46.0/255.0, alpha: 1.0)
  }
}
