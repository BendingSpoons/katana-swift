# Bending Spoons Katana Guidelines

This document is a collection of best practices and guidelines we defined throughout these years at [Bending Spoons](http://bendingspoons.com) for using Katana.

  * [Goals](#goals)
  * [Guidelines](#guidelines)
      - [1. Use Managers to encapsulate the logic](#1-use-managers-to-encapsulate-the-logic)
      - [2. Event Observers](#2-event-observers)
      - [3. Avoid complex Side Effects](#3-avoid-complex-side-effects)
      - [4. Leverage encapsulation, modularisation and visibility modifiers](#4-leverage-encapsulation--modularisation-and-visibility-modifiers)
      - [5. Document](#5-document)
      - [6. Project files structure](#6-project-files-structure)
  * [How to contribute](#how-to-contribute)

## Goals

Since the very early days of Bending Spoons, we enjoyed defining and sharing guidelines and best practices across all our projects. This has some incredible advantages:

* When there are multiple equivalent ways to doing a thing, picking one and being consistent allows everyone to immediately understand how things work and how to introduce changes to an application or a library, even if they are not familiar with the codebase.
* By following shared patterns, we can implement tools with the assumption that some things are done in a specific way.
* When reviewing Pull Requests, one can leverage guidelines to provide effective feedback.
* New spooners can have a head start thanks to the consolidated written knowledge that the guidelines carry over.

It is also important to define what this document is not. This document is not something that prevents you from exploring, testing and suggesting new ways of doing things. Exploration and curiosity are what allowed us to write this document, and they will be as important in the future to keep improving it. Nothing is set in stone, and everything is challengable. If you want to contribute to this document, see "How to contribute" section 💪.

## Guidelines

<a href="1"></a>
#### 1. Use Managers to encapsulate the logic

In order to accomplish the best possible level of modularization and reusability to our code, we define objects, that we call Manager. A manager is responsible for handling specific parts of our business logic.
A fitness app could for example, needs a Login Manager, a Plan Generator, and even more generic logic to perform API calls or to track users metrics.

The dependency container is responsible of initiatiating these managers and exposing them to Katana's side effects. Here are some guidelines to follow when creating a manager:

* Managers are "passive", they are invoked by Katana `Side Effects` and they shouldn't interact with Katana in any way (that is, they cannot dispatch)
* As a consequence, managers shouldn't have access to the neither the Store `getState` nor `dispatch`
* Managers shouldn't contain state. All the pieces of information that functions need to perform their calculations are passed as parameters.
* Managers might need to use other managers to implement part of their logic. We call these subordinate managers dependencies. Dependencies should be passed as parameters when initializing the manager.

When it comes to the naming convention, classes that act as Managers should be named with the `Manager` suffix. To make a concrete example, `Login` is not a valid manager's name, while `LoginManager` is.

<a href="2"></a>
#### 2. Event Observers

Katana offers an `Interceptor` that can be used to observe the following events:

* state changes
* a `StateUpdater` or a `Side Effect` has been dispatched
* a `Notification` has been posted

Sometimes this is not enough and we need to observe the external world and bring the information we get from this observation back in the Katana world. As discussed in the [guideline (1)](#1-use-managers-to-encapsulate-the-logic), Managers are a passive member of our applications and therefore they cannot dispatch.

To address this particular use case, we introduce `EventObservers`. These classes are created and owned by the dependency container and have the only and single responsibility of listening for events coming from the external world (e.g., Firebase, Websockets, ...) and dispatch something back in the `Katana` world as a consequence of this event.

While it may seem odd to separate Managers and `EventObservers`, this actually helps in keeping every piece simple and consistent. Use managers for simple cases and `EventObservers` for more complex.

When it comes to the naming convention, classes that act as EventObservers should be named with the `Observer` suffix. To make a concrete example, `HealthKit` is not a valid manager's name, while `HealthKitObserver` is.

<a href="3"></a>

#### 3. Avoid complex Side Effects

When writing the logic of the applications, the temptation would be to create some high flexible side effects that take several inputs (that is, the struct that implements the side effects has several parameters) and implements different things according to these inputs.

While code reuse is a great tool in software development, we noticed that applying this to Side effects leads to less maintainable applications. Moreover, assuming you are following [guideline (1)](#1-use-managers-to-encapsulate-the-logic), the logic is encapsulated in grouped, reusable functions. This means that you should try to keep Side effects simple and as close as possible to a simple chaining of managers functions and dispatches. 

Regarding dispatching a side effect inside another side effect, it should be avoided if possible as it makes the whole logic more hard to follow. If you end up being in this situation, try to look at your code and consider leveraging managers more.

<a href="4"></a>

#### 4. Leverage encapsulation, modularisation and visibility modifiers

Applications are a composition of separated logical parts that collaborate together. When writing the logic of an application, you should create namespaces (modules) that reflect this division and group state updaters and side effects in these namespaces.

As an example, you can do something like this:

```swift
enum LoginActions {
  struct PerformLogin: SideEffect { 
    // some code here
  }
}
```

Namespaces can also be used to hide implementation details (that is, state updaters or side effects)  you don't want to expose to the whole application:

```swift
enum LoginActions {
  // this will be available globally to the application
  struct PerformLogin: SideEffect { 
    // some code here
    // ... then dispatch SetUser
  }
}

fileprivate extension LogincActions {
  // this is an internal implementation detail
  fileprivate struct SetUser: StateUpdater {
    // some code here
  }
}
```

This division basically creates a "public interface" of the module in addition to (optional) dispatchable items that are implementation details. Having some state updaters or side effects that are not available in the interface makes it easier to refactor the code and/or change the implementation of the modules.

For more complex situations, you can even have the portion of the state that is managed by a module in the very same file of the module itself. In this way, you can have variables that can be modified just by the state updater structs of the module and not by some other pieces of the application. This increases even more the modularization of your application, and guarantees that certain information is only updated by code co-located with the state.

<a href="5"></a>

#### 5. Documentation

Documentation is a very important part of the applications. Having a great documentation allows other developers to jump in your codebase easily and be productive sooner. 

[Guideline (4)](#4-leverage-encapsulation-modularisation-and-visibility-modifiers) defines the concept of public interface for a logic module. When applying that guideline to your code, you should also make sure the "public interface" if properly documented. A good documentation should include:

* A description of what the function/side effect/state updater does
* A description of the parameters
* Preconditions, if any
* Assumptions made during the development of the piece of code
* Any other information that cannot be easily inferred by the code and that is useful both when using the code or when someone has to change it

<a href="6"></a>

#### 6. Project files structure

Projects can be organised in multiple ways. Each has pros and cons. Most of the time the looks of a project depends on things like personal taste and personal preferences. However, having a shared project structure allows everyone to look at other people's code and properly understand where things are located.

Here we define how Bending Spoons projects should be organised. It is the result of different iterations and optimizations.

Assuming we have an application with two logic modules (Login and Plan Generator) and two UI sections (Login and  Home), here is how the project structure should look like:

```
ProjectName
    |-- Logic
          |-- AppDependenciesContainer.swift
          |-- Home
                |-- HomeDispatchable.swift  // side effects and state updaters        
          |-- Login
                |-- LoginDispatchable.swift // side effects and state updaters
                |-- LoginManager.swift
          |-- PlanGenerator
                |-- PlanGeneratorDispatchable.swift // side effects and state updaters
                |-- PlanGeneratorModels.swift 
                |-- PlanGeneratorManager.swift 
    |-- UI
          |-- Login
                |-- LoginVC.swift
                |-- LoginView.swift  
          |-- Home
                |-- HomeVC.swift
                |-- HomeView.swift    
                |-- HomeVM.swift
    |-- State
          |-- AppState.swift    
```

As you can see, the main folder contains 3 main folders: Logic, UI and State.

The logic folder contains all the logic of the application (state updaters, side effects and managers) and the dependencies container.

The logic is based on [guideline (4)](#4-leverage-encapsulation-modularisation-and-visibility-modifiers). Even if all the logic is in a single file (e.g., Home.swift, which holds side effects strictly related to the `Home` view controller), the file should be included in a folder to faciliate the search without having to guess if it's a folder or a file. Overall logic should contain side effects, state updaters, managers and models related to the logic.

The State folder contains all the structures that are part of the state. Note that, following  [guideline (4)](#4-leverage-encapsulation-modularisation-and-visibility-modifiers), you may want to co-locate the state with the logic to implement some information-hiding technique to your code (that is, put some variables private or file-private). This is the only allowed exception.

The UI folder is represented just for reference and should follow Tempura (or any other UI framework you are using) guidelines.

## How to contribute

Everything in Bending Spoons can and should be challenged, and these guidelines are not an exception. If you feel something is wrong or can be improved, just open a PR with your proposal.

Stay strong and keep coding 💪.
