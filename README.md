![Katana](https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/Assets/katana_header.png)

[![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/fold_left.svg?style=social&label=Follow%20katana_swift)](https://twitter.com/katana_swift)
[![Build Status](https://travis-ci.org/BendingSpoons/katana-swift.svg?branch=master)](https://travis-ci.org/BendingSpoons/katana-swift)
[![Docs](https://img.shields.io/cocoapods/metrics/doc-percent/Katana.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Katana.svg)]()
[![Licence](https://img.shields.io/badge/Licence-MIT-lightgrey.svg)](https://github.com/BendingSpoons/katana-swift/blob/master/LICENSE)


Katana is a modern Swift framework for writing iOS and macOS apps, strongly inspired by [React](https://facebook.github.io/react/) and [Redux](http://redux.js.org/), that gives structure to all the aspects of your app:

- __logic__: the app state is entirely described by a single serializable data structure, and the only way to change the state is to dispatch an action. An action is an intent to transform the state, and contains all the information to do so. Because all the changes are centralized and are happening in a strict order, there are no subtle race conditions to watch out for.
- __UI__: the UI is defined in terms of a tree of components declaratively described by props (the configuration data, i.e. a background color for a button) and state (the internal state data, i.e. the highlighted state for a button). This approach lets you think about components as isolated, reusable pieces of UI, since the way a component is rendered only depends on the current props and state of the component itself.
- __logic__ ↔️ __UI__: the UI components are connected to the app state and will be automatically updated on every state change. You control how they change, selecting the portion of app state that will feed the component props. To render this process as fast as possible, only the relevant portion of the UI is updated. 
- __layout__: Katana defines a concise language (inspired by [Plastic](https://github.com/BendingSpoons/plastic-lib-iOS)) to describe fully responsive layouts that will gracefully scale at every aspect ratio or size, including font sizes and images.


We feel that Katana helped us a lot since we started using it in production. At [Bending Spoons](http://www.bendingspoons.com) we use a lot of open source projects ourselves and we wanted to give something back to the community, hoping you will find this useful and possibly contribute. ❤️ 



|      | Katana                                   |
| ---- | ---------------------------------------- |
| 🎙   | Declaratively define your UI             |
| 📦   | Store all your app state in a single place |
| 💂   | Clearly define what are the actions that can change the state |
| 😎   | Describe asynchronous actions like HTTP requests |
| 💪   | Support for middleware                   |
| 🎩   | Automatically update the UI when your app state changes |
| 📐   | Automatically scale your UI to every size and aspect ratio |
| 🐎   | Easily animate UI changes                |





## Overview

### Defining the logic of your app

Your entire app `State` is defined in a single struct, all the relevant application information should be placed here.

```swift
struct CounterState: State {
  var counter: Int = 0
}
```

The app `State` can only be modified by an `Action`. An `Action` represents an event that leads to a change in the `State` of the app. There are two kind of actions: `SyncAction` and `AsyncAction`. You define the behaviour of the action implementing the `updatedState()` method that will return the new app `State` based on the current app `State` and the `Action` itself.

```swift
struct IncrementCounter: SyncAction {
  var payload: ()

  func updatedState(currentState: State) -> State {
    guard var state = currentState as? CounterState else { fatalError("wrong state type") 	  }
    state.counter += 1
    return state
  }
}
```

The `Store` contains and manages your entire app `State` and it is responsible for dispatching `Actions` and updating the `State`.

```swift
let store = Store<CounterState>()
store.dispatch(IncrementCounter())
```

You can ask the `Store` to be notified about every change in the app `State`.

```swift
store.addListener() {
  // the app state has changed
}
```



### Defining the UI

In Katana you declaratively describe a specific piece of UI providing a  `NodeDescription`. Each `NodeDescription` will define the component in terms of:

- `StateType` the internal state of the component (es. highlighted for a button)
- `PropsType` the inputs coming from outside the component (es. backgroundColor for a view)
- `NativeView` the UIKit/AppKit element associated with the component

```swift
struct CounterScreen: NodeDescription {
	typealias StateType = EmptyState
	typealias PropsType = CounterScreenProps
	typealias NativeView = UIView
	
	var props: PropsType
}
```

Inside the `props` you want to specify all the inputs needed to render your `NativeView` and to feed your children components.

```swift
struct CounterScreenProps: NodeDescriptionProps {
  var count: Int = 0
  var frame: CGRect = .zero
  var alpha: CGFloat = 1.0
  var key: String?
}
```

When it's time to render the component, the method `applyPropsToNativeView` is called: this is where we need to adjust our nativeView to reflect the  `props` and the `state`. _Note that for common properties like frame, backgroundColor and more we already provide a standard [applyPropsToNativeView](https://github.com/BendingSpoons/katana-swift/blob/master/KatanaElements/View.swift) so we got you covered._

```swift
struct CounterScreen: NodeDescription {
  ...
  public static func applyPropsToNativeView(props: PropsType,
  											state: StateType,
  											view: NativeView, ...) {
  	view.frame = props.frame
  	view.alpha = props.alpha
  }
}
```

`NodeDescriptions` lets you split the UI into small independent, reusable pieces. That's why it is very common for a `NodeDescription` to be composed by other `NodeDescription`s as children, generating the UI tree. To define child components, implement the method `childrenDescriptions`.

```swift
struct CounterScreen: NodeDescription {
  ...
  public static func childrenDescriptions(props: PropsType,
  											state: StateType, ...) -> 	  [AnyNodeDescription] {
  	return [
  		Label(props: LabelProps.build({ (labelProps) in
          labelProps.key = CounterScreen.Keys.label.rawValue
          labelProps.textAlignment = .center
          labelProps.backgroundColor = .mediumAquamarine
          labelProps.text = NSAttributedString(string: "Count: \(props.count)")
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
}
```



### Attaching the UI to the Logic

The `Renderer` is responsible for rendering the UI tree and updating it when the `Store` changes. 

You create a `Renderer` object starting from the top level `NodeDescription` and the `Store`.

```
renderer = Renderer(rootDescription: counterScreen, store: store)
renderer.render(in: view)
```

Every time a new app `State` is available, the `Store` dispatches an event that is captured by the `Renderer ` and dispatched down to the tree of UI components.
If you want a component to receive updates from the `Store` just declare its `NodeDescription` as `ConnectedNodeDescription` and implement the method `connect` to attach the app `Store` to the component `props`.

```
struct CounterScreen: ConnectedNodeDescription {
  ...
  static func connect(props: inout PropsType, to storeState: StateType) {
  	props.count = storeState.counter
  }
}
```



### Layout of the UI

Katana has its own language (inspired by [Plastic](https://github.com/BendingSpoons/plastic-lib-iOS)) to programmatically define fully responsive layouts that will gracefully scale at every aspect ratio or size, including font sizes and images.
If you want to opt in, just implement the `PlasticNodeDescription` protocol and its `layout` method where you can define the layout of the children, based on the given `referenceSize`. The layout system will use the reference size to compute the proper scaling. 

```swift
struct CounterScreen: ConnectedNodeDescription, PlasticNodeDescription, PlasticReferenceSizeable {
  ...
  static var referenceSize = CGSize(width: 640, height: 960)
  
  static func layout(views: ViewsContainer<CounterScreen.Keys>, props: PropsType, state: StateType) {
    let nativeView = views.nativeView
    
    let label = views[.label]!
    let decrementButton = views[.decrementButton]!
    let incrementButton = views[.incrementButton]!
    label.asHeader(nativeView)
    [label, decrementButton].fill(top: nativeView.top, bottom: nativeView.bottom)
    incrementButton.top = decrementButton.top
    incrementButton.bottom = decrementButton.bottom
    [decrementButton, incrementButton].fill(left: nativeView.left, right: nativeView.right)
  }
}
```

### Note for layout in macOS

Plastic is assuming that the coordinate system has its origin at the upper left corner of the drawing area (like in iOS), so if you want to use plastic on macOS, remember to specify `isFlipped = true` for all your custom native AppKit views that have children components. All the components we provide are already following this convention.

### You can find the complete example [here](https://github.com/BendingSpoons/katana-swift/blob/master/Demo)

<table>
  <tr>
    <th>
      <img src="https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/Assets/demo_counter.gif" width="300"/>
    </th>
  </tr>
</table>



## Where to go from here

### Getting started tutorial
We wrote a [getting started tutorial](https://github.com/BendingSpoons/katana-tutorial-swift). It is currently a work in progress, but it will be finished soon!

### Give it a shot

```
pod try Katana
```

### Explore sample projects

<table>
 <tr>
  <th>
    <img src="https://github.com/BendingSpoons/katana-swift/blob/master/Assets/demo_pokeAnimation.gif?raw=true" width="200"/>
  </th>
  <th>
    <img src="https://github.com/BendingSpoons/katana-swift/blob/master/Assets/demo_codingLove.gif?raw=true" width="200"/>
  </th>
  <th>
    <img src="https://github.com/BendingSpoons/katana-swift/blob/master/Assets/demo_minesweeper.gif?raw=true" width="200"/>
  </th>
 </tr>
 <tr>
  <th>
   <a href="https://github.com/BendingSpoons/katana-swift/blob/master/Examples/PokeAnimations">Animations Example</a>
  </th>
  <th>
   <a href="https://github.com/BendingSpoons/katana-swift/blob/master/Examples/CodingLove">Table Example</a>
  </th>
  <th>
   <a href="https://github.com/BendingSpoons/katana-swift/blob/master/Examples/Minesweeper">Minesweeper Example</a>
  </th>
 </tr>
</table>

### Check out the documentation

[Documentation](http://katana.bendingspoons.com)


## Installation

Katana is available through [CocoaPods](https://cocoapods.org/) and [Carthage](https://github.com/Carthage/Carthage), you can also drop `Katana.project` into your Xcode project.

### Requirements

- iOS 8.4+ / macOS 10.10+

- Xcode 8.0+

- Swift 3.0+

  ​

### CocoaPods

 [CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ sudo gem install cocoapods
```

To integrate Katana into your Xcode project using CocoaPods, add it to your `Podfile`:

```
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.4'

pod 'Katana'
pod 'KatanaElements'
```

And run:

```bash
$ pod install
```



### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager for Cocoa projects. 
You can install Carthage downloading and running the `Carthage.pkg` file you can download from [here](https://github.com/Carthage/Carthage/releases) or you can install it using [Homebrew](http://brew.sh/) simply by running:

```bash
$ brew update
$ brew install carthage
```

To integrate Katana into your Xcode project using Carthage, add it to your `Cartfile`:

```
github "Bendingspoons/katana-swift"
```

And Run:

```bash
$ carthage update
```

Then drag the built `Katana.framework` and `KatanaElements.framework` into your Xcode project.



## Roadmap

- [x] immutable state


- [x] unidirectional data flow


- [x] sync/async/sideEffect actions
- [x] middlewares
- [x] automatic UI update
- [x] native redux-like implementation
- [x] native react-like implementation
- [x] declarative UI
- [x] leverage Plastic layout engine
- [ ] support other layout engines
- [ ] declarative Table element
- [x] macOS support
- [ ] improve test coverage
- [ ] expand documentation
- [ ] write an example about wrapping UIKit view controllers



## Get in touch 

- if you have __any questions__ you can find us on twitter: [@maurobolis](https://twitter.com/maurobolis), [@luca_1987](https://twitter.com/luca_1987), [@smaramba](https://twitter.com/smaramba)

## Special thanks

- [Everyone at Bending Spoons](http://bendingspoons.com/team.html) for providing their priceless input;
- [@orta](https://twitter.com/orta) for providing input on how to opensource the project.

## Contribute

- If you've __found a bug__, open an issue;
- If you have a __feature request__, open an issue;
- If you __want to contribute__, submit a pull request;
- If you __have an idea__ on how to improve the framework or how to spread the word, please [get in touch](#get-in-touch);
- If you want to __try the framework__ for your project or to write a demo, please send us the link of the repo.

We'll be happy to send you a sticker with the logo as a sign of appreciation for any meaningful contribution.

## License

Katana is available under the [MIT license](https://github.com/BendingSpoons/katana-swift/blob/master/LICENSE).

## About

Katana is maintained by Bending Spoons.
We create our own tech products, used and loved by millions all around the world.
Interested? [Check us out](http://bndspn.com/2fKggTa)!

