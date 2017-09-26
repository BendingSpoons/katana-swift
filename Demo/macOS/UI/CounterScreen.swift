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
    case countButton
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
  typealias NativeView = NSViewCustom

  var props: PropsType

  static var referenceSize = CGSize(width: 700, height: 500)

  public static func childrenDescriptions(props: PropsType,
                                          state: StateType,
                                          update: @escaping (StateType) -> (),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {

    return [
      Button(props: Button.Props.build({
        $0.setKey(Keys.countButton)
        $0.backgroundColor = .mediumAquamarine
        $0.title = "Count: \(props.count)".centered
      })),
      Button(props: Button.Props.build({
        $0.setKey(Keys.decrementButton)
        $0.backgroundColor = .dogwoodRose
        $0.backgroundHighlightedColor = NSColor.dogwoodRose.darkish
        $0.title = "Decrement".centered
        $0.clickHandler = { button in
          dispatch(DecrementCounter())
        }
      })),
      Button(props: Button.Props.build({
        $0.setKey(Keys.incrementButton)
        $0.backgroundColor = .japaneseIndigo
        $0.backgroundHighlightedColor = NSColor.japaneseIndigo.darkish
        $0.title = "Increment".centered
        $0.clickHandler = { button in
          dispatch(IncrementCounter())
        }
      }))
    ]
  }

  public static func connect(props: inout PropsType, to storeState: CounterState) {
    props.count = storeState.counter
  }

  public static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) {
    let rootView = views.nativeView

    let label = views[.countButton]!
    let decrementButton = views[.decrementButton]!
    let incrementButton = views[.incrementButton]!
    label.asHeader(rootView)
    [label, decrementButton].fill(top: rootView.top, bottom: rootView.bottom)
    incrementButton.top = decrementButton.top
    incrementButton.bottom = decrementButton.bottom
    [decrementButton, incrementButton].fill(left: rootView.left, right: rootView.right)
  }
}

extension String {
  func attributed(key: NSAttributedStringKey, value: Any) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: self, attributes: [key: value])
  }

  var centered: NSMutableAttributedString {
    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    return self.attributed(key: NSAttributedStringKey.paragraphStyle, value: style)
  }
}

extension NSMutableAttributedString {
  func attributed(key: NSAttributedStringKey, value: Any) -> NSMutableAttributedString {
    self.addAttribute(key, value: value, range: self.string.fullRange)
    return self
  }
}

extension String {
  var fullRange: NSRange {
    return NSRange(location:0, length: self.characters.count)
  }
}

extension NSColor {
  static var mediumAquamarine: NSColor {
    return NSColor(red: 89.0/255.0, green: 201.0/255.0, blue: 165.0/255.0, alpha: 1.0)
  }

  static var dogwoodRose: NSColor {
    return NSColor(red: 216.0/255.0, green: 30.0/255.0, blue: 91.0/255.0, alpha: 1.0)
  }

  static var japaneseIndigo: NSColor {
    return NSColor(red: 35.0/255.0, green: 57.0/255.0, blue: 91.0/255.0, alpha: 1.0)
  }

  static var jet: NSColor {
    return NSColor(red: 51.0/255.0, green: 49.0/255.0, blue: 46.0/255.0, alpha: 1.0)
  }

  var darkish: NSColor {
    let red: CGFloat = CGFloat(self.redComponent)
    let green: CGFloat = CGFloat(self.greenComponent)
    let blue: CGFloat = CGFloat(self.blueComponent)
    let alpha: CGFloat = CGFloat(self.alphaComponent)
    let darkishDelta: CGFloat = 0.03
    return NSColor(red: max(0.0, red - darkishDelta),
                   green: max(0.0, green - darkishDelta),
                   blue: max(0.0, blue - darkishDelta),
                   alpha: alpha)
  }
}
