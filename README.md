
![Katana](https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/.github/Assets/katana_header.png)

[![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/fold_left.svg?style=social&label=Follow%20katana_swift)](https://twitter.com/katana_swift)
[![Build Status](https://github.com/BendingSpoons/katana-swift/workflows/Build%20and%20Test/badge.svg)](https://github.com/BendingSpoons/katana-swift/workflows/Build%20and%20Test/)
[![Docs](https://img.shields.io/cocoapods/metrics/doc-percent/Katana.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/Katana.svg)]()
[![Licence](https://img.shields.io/badge/Licence-MIT-lightgrey.svg)](https://github.com/BendingSpoons/katana-swift/blob/master/LICENSE)

Katana is a modern Swift framework for writing iOS applications' business logic that are testable and easy to reason about. Katana is strongly inspired by [Redux](http://redux.js.org/).

In few words, the app state is entirely described by a single serializable data structure, and the only way to change the state is to dispatch a `StateUpdater`. A `StateUpdater` is an intent to transform the state, and contains all the information to do so. Because all the changes are centralized and are happening in a strict order, there are no subtle race conditions to watch out for.

We feel that Katana helped us a lot since we started using it in production. Our applications have been downloaded several milions of times and Katana really helped us scaling them quickly and efficiently. [Bending Spoons](http://www.bendingspoons.com)'s engineers leverage Katana capabilities to design, implement and test complex applications very quickly without any compromise to the final result. 

We use a lot of open source projects ourselves and we wanted to give something back to the community, hoping you will find this useful and possibly contribute. ❤️ 

## Overview

Your entire app `State` is defined in a single struct, all the relevant application information should be placed here.

```swift
struct CounterState: State {
  var counter: Int = 0
}
```

The app `State` can only be modified by a `StateUpdater`. A `StateUpdater` represents an event that leads to a change in the `State` of the app. You define the behaviour of the `State Updater` by implementing the `updateState(:)` method that changes the `State` based on the current app `State` and the `StateUpdater` itself. The `updateState` should be a pure function, which means that it only depends on the inputs (that is, the state and the state updater itself) and it doesn't have side effects, such as network interactions.

```swift
struct IncrementCounter: StateUpdater {
  func updateState(_ state: inout CounterState) {
    state.counter += 1
  }
}
```

The `Store` contains and manages your entire app `State`. It is responsible of managing the dispatched items (e.g., the just mentioned `State Updater`).

```swift
// ignore AppDependencies for the time being, it will be explained later on
let store = Store<CounterState, AppDependencies>()
store.dispatch(IncrementCounter())
```

You can ask the `Store` to be notified about every change in the app `State`.

```swift
store.addListener() {
  // the app state has changed
}
```



## Side Effects

Updating the application's state using pure functions is nice and it has a lot of benefits. Applications have to deal with the external world though (e.g., API call, disk files management, …). For all this kind of operations, Katana provides the concept of  `side effects`. Side effects can be used to interact with other parts of your applications and then dispatch new `StateUpdater`s to update your state. For more complex situations, you can also dispatch other `side effects`.

`Side Effect`s are implemented on top of [Hydra](https://github.com/malcommac/Hydra/), and allow you to write your logic using [promises](https://promisesaplus.com/). In order to leverage this functionality you have to adopt the `SideEffect` protocol

```swift
struct GenerateRandomNumberFromBackend: SideEffect {
  func sideEffect(_ context: SideEffectContext<CounterState, AppDependencies>) throws {
    // invokes the `getRandomNumber` method that returns a promise that is fullfilled
    // when the number is received. At that point we dispatch a State Updater
    // that updates the state
    context.dependencies.APIManager
        .getRandomNumber()
        .thenDispatch({ newValue in SetCounter(newValue: newValue) })
  }
}

struct SetCounter: StateUpdater {
  let newValue: Int
  
  func updateState(_ state: inout CounterState) {
    state.counter = self.newValue
  }
}
```

 Moreover, you can leverage the `await` operator to write logic that mimics the [Async/Await](https://github.com/tc39/ecmascript-asyncawait) pattern, which allows you to write async code in a sync manner.

```swift
struct GenerateRandomNumberFromBackend: SideEffect {
  func sideEffect(_ context: SideEffectContext<CounterState, AppDependencies>) throws {
    // invokes the `getRandomNumber` method that returns a promise that is fullfilled
    // when the number is received.
    let promise = context.dependencies.APIManager.getRandomNumber()
    
    // we use await to wait for the promise to be fullfilled
    let newValue = try await(promise)

    // then the state is updated using the proper state updater
    try await(context.dispatch(SetCounter(newValue: newValue)))
  }
}
```

#### Dependencies

The side effect example leverages an `APIManager` method. The `Side Effect` can get the `APIManager` by using the `dependencies` parameter of the context.  The `dependencies container` is the Katana way of doing dependency injection. We test our side effects, and because of this we need to get rid of singletons or other bad pratices that prevent us from writing tests. Creating a dependency container is very easy: just create a class that conforms to the `SideEffectDependencyContainer` protocol, make the store generic to it, and use it in the side effect.

```swift
final class AppDependencies: SideEffectDependencyContainer {
  required init(dispatch: @escaping PromisableStoreDispatch, getState: @escaping GetState) {
		// initialize your dependencies here
	}
}
```

## Interceptors

When defining a `Store` you can provide a list of interceptors that are triggered in the given order whenever an item is dispatched. An interceptor is like a catch-all system that can be used to implement functionalities such as logging or to dynamically change the behaviour of the store. An interceptor is invoked every time a dispatchable item is about to be handled.

#### DispatchableLogger
 Katana comes with a built-in `DispatchableLogger` interceptor that logs all the dispatchables, except the ones listed in the blacklist parameter.

```swift
let dispatchableLogger = DispatchableLogger.interceptor(blackList: [NotToLog.self])
let store = Store<CounterState>(interceptor: [dispatchableLogger])
```

#### ObserverInterceptor
Sometimes it is useful to listen for events that occur in the system and react to them. Katana provides the `ObserverInterceptor` that can be used to achieve this result.

In particular you instruct the interceptor to dispatch items when:

* the store is initialized
* the state changes in a particular way
* a particular dispatchable item is managed by the store
* a particular notification is sent to the default [NotificationCenter](https://developer.apple.com/documentation/foundation/nsnotificationcenter)

```swift
let observerInterceptor = ObserverInterceptor.observe([
  .onStart([
    // list of dispatchable items dispatched when the store is initialized
  ])
])

let store = Store<CounterState>(interceptor: [observerInterceptor])
```

## What about the UI?

Katana is meant to give structure to the logic part of your app. When it comes to UI we propose two alternatives:

- [Tempura](https://github.com/BendingSpoons/tempura-swift): an MVVC framework we built on top of Katana and that we happily use to develop the UI of all our apps at Bending Spoons.  Tempura is a lightweight, UIKit-friendly library that allows you to keep the UI automatically in sync with the state of your app. This is our suggested choice.

- [Katana-UI](https://github.com/BendingSpoons/katana-ui-swift): With this library, we aimed to port React to UIKit, it allows you to create your app using a declarative approach. The library was initially bundled together with Katana, we decided to split it as internally we don't use it anymore. In retrospect, we found that the impedance mismatch between the React-like approach and the imperative reality of UIKit was a no go for us.

<p align="center">
  <a href="https://github.com/BendingSpoons/tempura-swift"><img src="https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/.github/Assets/tempura.png" alt="Tempura" width="240" /></a>
  <a href="https://github.com/BendingSpoons/katana-ui-swift"><img src="https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/.github/Assets/katanaUI.png" alt="Katana UI" width="240" /></a>
</p>

## Signpost Logger

Katana is automatically integrated with the [Signpost API](https://developer.apple.com/documentation/os/ossignpostid). This integration layer allows you to see in Instruments all the items that have been dispatched, how long they last, and useful pieces of information such as the parallelism degree. Moreover, you can analyse the cpu impact of the items you dispatch to furtherly optimise your application performances.

![](https://raw.githubusercontent.com/BendingSpoons/katana-swift/master/.github/Assets/signpost.jpg)

## Bending Spoons Guidelines

In Bending Spoons, we are extensively using Katana. In these years, we've defined some best pratices that have helped us write more readable and easier to debug code. We've decided to open source them so that everyone can have a starting point when using Katana. You can find them [here](https://github.com/BendingSpoons/katana-swift/blob/master/BSP_GUIDELINES.md).

## Migration from 2.x

We strongly suggest to upgrade to the new Katana. The new Katana, in fact, not only adds new very powerful capabilities to the library, but it has also been designed to be extremely compatible with the old logic. All the actions and middleware you wrote for Katana 2.x, will continue to work in the new Katana as well. The breaking changes are most of the time related to simple typing changes that are easily addressable.

If you prefer to continue with Katana 2.x, however, you can still access Katana 2.x in the [dedicated branch](https://github.com/BendingSpoons/katana-swift/tree/2.x).

### Middleware
In Katana, the concept of `middleware` has been replaced with the new concept of `interceptor`. You can still use your middleware by leveraging the `middlewareToInterceptor` method.

## Swift Version
Certain versions of Katana only support certain versions of Swift. Depending on which version of Swift your project is using, you should use specific versions of Katana.
Use this table in order to check which version of Katana you need.

| Swift Version  | Katana Version |
| ------------- | ------------- |
| Swift 4.2 | Katana >= 2.0  |
| Swift 4.1 | Katana < 2.0 |


## Where to go from here

### Give it a shot

```
pod try Katana
```

### Tempura

Make awesome applications using Katana together with [Tempura](https://github.com/BendingSpoons/tempura-lib-swift)

### Check out the documentation

[Documentation](http://katana.bendingspoons.com)

You can also add Katana to [Dash](https://kapeli.com/dash) using the proper [docset](https://github.com/BendingSpoons/katana-swift/blob/master/docs/latest/docsets/Katana.tgz?raw=true).

## Installation

Katana is available through [CocoaPods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage) and [Swift Package Manager](https://swift.org/package-manager/), you can also drop `Katana.project` into your Xcode project.

### Requirements

- iOS 9.0+ / macOS 10.10+

- Xcode 8.0+

- Swift 4.0+

### Swift Package Manager
[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

There are two ways to integrate Katana in your project using Swift Package Manager:
- Adding it to your `Package.swift`
- Adding it directly from Xcode under `File` -> `Swift Packages` -> `Add Package dependency..`

In both cases you only need to provide this URL: `git@github.com:BendingSpoons/katana-swift.git`

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
platform :ios, '9.0'

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
- [@orta](https://twitter.com/orta) for providing input on how to opensource the project;
- [@danielemargutti](https://twitter.com/danielemargutti/) for developing and maintaining [Hydra](https://github.com/malcommac/Hydra/);

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

