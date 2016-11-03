# Katana

## A modern framework for well-behaved apps

Katana is a modern swift framework for writing iOS apps originated from our love for the react/redux philosophy and the lack of an existing native swift implementation.
Katana gives structure to all the aspects of your app from the Logic to the UI, encapsulating state management and updating the UI automatically:

- __logic__: like in  [Redux](https://github.com/reactjs/redux), in a Katana app all the state is entirely described by a single serializable data structure (store) and the only way to change the state is to emit an action. An action is an intent to transform the state and contains all the informations to do so. Because all the changes are centralized and are happening in a strict order, there are no subtle race conditions to watch out for.
- __UI__: like in [React](https://facebook.github.io/react/), you define your UI in terms of a tree of components declaratively described by props (external world) and state (internal world). This approach lets you think about components as an isolated, reusable piece of UI, since the way a component is rendered only depends on the current props and state of the component itself.
- __logic<->UI__: in Katana your UI components are attached to the store and will be automatically updated on every state change. You control how they change, connecting the store state to the component props.
- __layout__: Katana defines a concise language to describe fully responsive layouts that will gracefully scale at every aspect ratio or size, including font sizes and images.


We feel that Katana helped us a lot since we started using it in production for more than X apps with XXXX active users per day. At BendingSpoons we use a lot of Open Sourced projects ourselves and we wanted to give something back to the community, hoping you will find this useful and possibly contribute. <3

### features

- [x] Immutable state
- [x] unidirectional data flow
- [x] sync/async/sideEffect actions
- [x] middlewares
- [x] automatic UI update
- [x] native redux-like implementation
- [x] native react-like implementation
- [x] declarative UI
- [x] leverage Plastic layout engine
- [ ] support other layout engines
- [ ] insert other missing thing here



## Installation

Katana is available through [CocoaPods](https://cocoapods.org/) and [Carthage](insert link here), you can also drop `Katana.project` into your XCode project.

### Requirements

- iOS 8.4+

- Xcode 8.0+

- Swift 3.0+


### CocoaPods

 [CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ sudo gem install cocoapods
```

To integrate Katana into your XCode project using CocoaPods, add it to your `Podfile`:

```
use_frameworks!
source [include project source here]
platform :ios, '8.4'

pod 'KatanaSwift'
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

To integrate Katana into your XCode project using Carthage, add it to your `Cartfile`:

```
github "Bendingspoons/KatanaSwift"
```

And Run:

```bash
$ carthage update
```

Then drag the built `Katana.framework` into your XCode project



## Overview

### defining the logic of your app

your entire app `State` is defined in a single struct:

```swift
struct ToDoState: State {
  var todos: [String]
}
```

the app `state` can only be modified by an `Action`. An action defines, in its `reduce()` method, the new app state based on the current app state and the action itself.

```swift
struct AddTodo: SyncAction {
  var payload: String
  
  static func reduce(state: State, action: AddToDo) -> State {
    guard var state = state as? ToDoState else { fatalError() }
    state.todos.append(action.payload)
    return state
  }
}
```

the `Store` stores your entire app `state` and it is responsible for dispatching the actions

```swift
let store = Store<ToDoState>()
store.dispatch(AddTodo("remember the milk"))
```

you can ask the `Store` to be notified for every change in the app state

```swift
store.addListener() {
  tableView.reloadData()
}
```



### defining the UI

Katana is inspired by [React](https://facebook.github.io/react/), you declaratively define your UI components called `NodesDescriptions`. Each `NodeDescription` will describe itself in terms of its internal `state` , the inputs coming from outside, called the `props` and the UIKit component this NodeDescription will be rendered as, the `NativeView`. 

```swift
struct ToDoScreen: NodeDescription {
	typealias StateType = EmptyState
	typealias PropsType = ToDoScreenProps
	typealias NativeView = UIView
	
	var props: ToDoScreenProps
}
```

Inside the `props` you want to specify all the inputs needed to render your `NativeView` and to feed your children components

```swift
struct ToDoScreenProps: NodeProps {
  var frame: CGRect = .zero
  var todos: [String] = []
}
```

When it's time to render the component, the method `applyPropsToNativeView` is called, this is where we need to adjust our nativeView to reflect the  `props` and the `state`

```swift
struct ToDoScreen: NodeDescription {
  ...
  public static func applyPropsToNativeView(props: ToDoScreenProps,
  											state: EmptyState,
  											view: UIView, ...) {
  	view.frame = props.frame
  }
}
```

`NodeDescriptions` lets you split the UI into small independent, reusable pieces. That's why it is very common for a `NodeDescription` to be composed by others `NodeDescription` as children. To define child components implement the method `childrenDescriptions`

```swift
struct ToDoScreen: NodeDescription {
  ...
  public static func childrenDescriptions(props: ToDoScreenProps,
  											state: EmptyState, ...) -> 	  [AnyNodeDescription] {
  	return [
  		Text(props: TextProps())
  			.key(.title)
  			.text("My awesome todos", fontSize: 15)
  			.borderColor(UIColor("#d54a0c"))
  		),
  		Table(props: TableProps()
  			.key(.todoList)
  			.delegate(ToDoListDelegate(todos: props.todos))
  		)
  	]
  }
}
```



### attaching the UI to the Logic

The `Root` object is responsible for connecting the `Store` to the tree of nodes that compose our UI.
You create a root object starting from the top level NodeDescription and the store.

```
let root = ToDoScreen(props: ToDoProps()).makeRoot(store: store)
```

Everytime a new app state is available the store emits an event that is captured by the Root and dispatched down to the tree of UI components.
If you want a node to receive updates from the `Store` just declare its `NodeDescription` as `ConnectedNodeDescription` and implement the method `connect` to attach the app `Store` to the component `props`

```
struct ToDoScreen: ConnectedNodeDescription {
  ...
  static func connect(props: inout ToDoScreenProps, to storeState: ToDoState) {
  	props.todos = storeState.todos
  }
}
```



### layout of the UI

Katana have its own language to programmatically define fully responsive layouts that will gracefully scale at every aspect ratio or size, including font sizes and images.
Each`NodeDescription` is responsible to define the layout of its children implementing the method `layout`. 

```swift
struct ToDoScreen: ConnectedNodeDescription {
  ...
  static func layout(views: ViewsContainer<ToDoKeys>, props: ToDoScreenProps, state: EmptyState) {
    let rootView = views.nativeView
    let title = views[.title]!
    let todoList = views[.todoList]!
    
    title.asHeader(rootView, insets: .scalable(30, 0, 0, 0))
    title.height = .scalable(60)
    
    todoList.fillHorizontally(rootView)
    todoList.top = title.bottom
    todoList.bottom = rootView.bottom
  }
}
```

You can find the complete example [here](insert link to the complete example)



## Where to go from here

### Explore sample projects

[insert here list of sample projects]

### Check out the documentation

[insert here link to the documentation]



## Communication

- If you __need help__, use [Stack Overflow](http://stackoverflow.com/questions/tagged/katanaswift) with tag 'katanaswift'

- if you have __any questions__ you can find us on twitter: @handle, @handle, @handle, ...

- If you __found a bug__, open an issue

- If you have a __feature request__, open an issue

- If you __want to contribute__, submit a pull request

  ​

## License

Katana is available under the [MIT license](insert link to LICENSE file here)
