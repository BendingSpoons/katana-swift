![Katana](https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/.github/Assets/katana_header.png)

[![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/fold_left.svg?style=social&label=Follow%20katana_swift)](https://twitter.com/katana_swift)
[![Build Status](https://travis-ci.org/BendingSpoons/katana-swift.svg?branch=master)](https://travis-ci.org/BendingSpoons/katana-swift)
[![Docs](https://img.shields.io/cocoapods/metrics/doc-percent/Katana.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Katana.svg)]()
[![Licence](https://img.shields.io/badge/Licence-MIT-lightgrey.svg)](https://github.com/BendingSpoons/katana-swift/blob/master/LICENSE)

Katana is a modern Swift framework for writing iOS applications business logic that are testable and easy to reason about. Katana is strongly inspired by [Redux](http://redux.js.org/).

In few words, the app state is entirely described by a single serializable data structure, and the only way to change the state is to dispatch an action. An action is an intent to transform the state, and contains all the information to do so. Because all the changes are centralized and are happening in a strict order, there are no subtle race conditions to watch out for.

We feel that Katana helped us a lot since we started using it in production. Our applications have been downloaded several milions of times and Katana really helped us scaling them quickly and efficiently. [Bending Spoons](http://www.bendingspoons.com)'s engineers leverage Katana capabilities to design, implement and test complex applications very quickly without any compromise to the final result. 

We use a lot of open source projects ourselves and we wanted to give something back to the community, hoping you will find this useful and possibly contribute. ❤️ 

## Overview

Your entire app `State` is defined in a single struct, all the relevant application information should be placed here.

```swift
struct CounterState: State {
  var counter: Int = 0
}
```

The app `State` can only be modified by an `Action`. An `Action` represents an event that leads to a change in the `State` of the app. You define the behaviour of the action implementing the `updatedState()` method that will return the new app `State` based on the current app `State` and the `Action` itself.

```swift
struct IncrementCounter: Action {
  func updatedState(currentState: State) -> State {
    guard var state = currentState as? CounterState else { return currentState }
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



## Side Effects

Updating the application's state using pure functions is nice and it has a lot of benefits. Applications have to deal with the external world though (e.g., API call, disk files management, …). For all this kind of operations, Katana provides the concept of  `side effects`. Side effects can be used to interact with other part of your applications and then dispatch new actions to update your state.

In order to leverage this functionality you have to adopt the `ActionWithSideEffect` protocol

```swift
struct IncrementCounter: ActionWithSideEffect {
  func updatedState(currentState: State) -> State {
	// some update state code here if needed
  }
    
  func sideEffect(
    currentState: State,
    previousState: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer) {
      
    // your logic here (e.g., network call)
  }
}
```

#### Dependencies

The last parameter of the side effect method signature is `dependencies`. This is the Katana way of doing dependency injection. We test our side effects, and because of this we need to get rid of singletons or other bad pratices that prevent us from writing tests. Create a dependency container is very easy: just create a class that implements the `SideEffectDependencyContainer` protocol and use it in the side effect

```swift
final class AppDependencies: SideEffectDependencyContainer {
    required init(dispatch: @escaping StoreDispatch, getState: @escaping () -> State) {
       // initialize your dependencies here
    }
}
```

## Middleware

When defining a `Store` you can provide a list of middleware layers that are triggered whenever an action is dispatched. Katana comes with a built in `ActionLogger` middleware that logs all the actions, but the one listed in the black list parameter.

```swift
let actionLogger = ActionLogger.middleware(blackList: [NotToLogAction.self])
let store = Store<CounterState>(middleware: [actionLogger], dependencies: AppDependencies.self)
```

## What about the UI?

Katana is meant to give structure to the logic part of your app. When it comes to UI we propose two alternatives:

- [Tempura](https://github.com/BendingSpoons/tempura-swift): an MVVC framework we built on top of Katana and that we happily use to develop the UI of all our apps at Bending Spoons.  Tempura is a lightweight, UIKit-friendly library that allows you to keep the UI automatically in sync with the state of your app. This is our suggested choice.

- [Katana-UI](https://github.com/BendingSpoons/katana-ui-swift): With this library, we aimed to port React to UIKit, it allows you to create your app using a declarative approach. The library was initially bundled together with Katana, we decided to split it as internally we don't use it anymore. In retrospect, we found that the impedance mismatch between the React-like approach and the imperative reality of UIKit was a no go for us.

<p align="center">
  <a href="https://github.com/BendingSpoons/tempura-swift"><img src="https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/.github/Assets/tempura.png" alt="Tempura" width="240" /></a>
  <a href="https://github.com/BendingSpoons/katana-ui-swift"><img src="https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/.github/Assets/katanaUI.png" alt="Katana UI" width="240" /></a>
</p>

## Where to go from here

### Give it a shot

```
pod try Katana
```

### Tempura

Make awesome applications using Katana together with [Tempura](https://github.com/BendingSpoons/tempura-lib-swift)

### Check out the documentation

[Documentation](http://katana.bendingspoons.com)

## Installation

Katana is available through [CocoaPods](https://cocoapods.org/) and [Carthage](https://github.com/Carthage/Carthage), you can also drop `Katana.project` into your Xcode project.

### Requirements

- iOS 8.4+ / macOS 10.10+

- Xcode 8.0+

- Swift 4.0+

### CocoaPods

 [CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ sudo gem install cocoapods
```

To integrate Katana into your Xcode project using CocoaPods you need to create a `Podfile`.

For iOS platforms, this is the content

```ruby
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.4'

target 'MyApp' do
  pod 'Katana'
end
```

Now, you just need to run:

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

Then drag the built `Katana.framework` into your Xcode project.

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


## License

Katana is available under the [MIT license](https://github.com/BendingSpoons/katana-swift/blob/master/LICENSE).

## About

Katana is maintained by Bending Spoons.
We create our own tech products, used and loved by millions all around the world.
Interested? [Check us out](http://bndspn.com/2fKggTa)!

