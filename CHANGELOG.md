# Changelog

## [6.0.0](https://github.com/BendingSpoons/katana-swift/tree/6.0.0) (2021-04-29)

- Provide old and new state to `StoreListener`s. [#216](https://github.com/BendingSpoons/katana-swift/pull/216)
- Bump Swift version to `5.0`. [#212](https://github.com/BendingSpoons/katana-swift/pull/212)
- Pin Hydra minimum version to `2.0.6`. [#212](https://github.com/BendingSpoons/katana-swift/pull/212)

## [5.1.1](https://github.com/BendingSpoons/katana-swift/tree/5.1.0) (2021-02-09)
- Make codebase compile with Swift 5.4 [#210](https://github.com/BendingSpoons/katana-swift/pull/210)
- Fix typos in documentation [#207](https://github.com/BendingSpoons/katana-swift/pull/207)

## [5.1.0](https://github.com/BendingSpoons/katana-swift/tree/5.1.0) (2020-11-27)
- Add `dependenciesInitializer` parameter to `Store` initializer

## [5.0.0](https://github.com/BendingSpoons/katana-swift/tree/5.0.0) (2020-10-09)
- Bump minDeploymentTarget from `8.3` to `11.0`
- Fix `Package.swift`
- Pin Hydra minimum version to `2.0.5`

## [4.0.0](https://github.com/BendingSpoons/katana-swift/tree/4.0.0) (2020-07-29)
- Add `ReturningSideEffect` protocol, in parallel to the already existing `SideEffect`
- Add a proper `dispatch` method for `ReturningSideEffect`s to return the values
- Update the README with explanations for the new behaviours
- Change `Dispatch` to `AnyDispach`
- Remove the `Action` (and `ActionWithSideEffect`) entities
- Bump Hydra to `2.0`

## [3.1.1](https://github.com/BendingSpoons/katana-swift/tree/3.1.1) (2019-03-26)
- Preserve interceptors order during execution.
  [\#189](https://github.com/BendingSpoons/katana-swift/pull/189) ([alextosatto](https://github.com/alextosatto))
- Fix tests

## [3.0.2](https://github.com/BendingSpoons/katana-swift/tree/3.0.2) (2019-09-05)
- Avoid `Promise.then()` on the main thread when possibile [\#175](https://github.com/BendingSpoons/katana-swift/pull/175) ([fonesti](https://github.com/fonesti))

## [3.0.1](https://github.com/BendingSpoons/katana-swift/tree/3.0.1) (2019-05-08)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/3.0.0...3.0.1)

**Merged pull requests:**

- \[FIX\] Send update to listeners when the state is initialized [\#172](https://github.com/BendingSpoons/katana-swift/pull/172) ([smaramba](https://github.com/smaramba))

## [3.0.0](https://github.com/BendingSpoons/katana-swift/tree/3.0.0) (2019-01-03)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/2.0.0...3.0.0)

**Implemented enhancements:**

- \[PROPOSAL\] enhanced app structuring [\#159](https://github.com/BendingSpoons/katana-swift/pull/159) ([TheInkedEngineer](https://github.com/TheInkedEngineer))

**Closed issues:**

- \[experimental\] ObserverInterceptor items executed more than once [\#163](https://github.com/BendingSpoons/katana-swift/issues/163)
- \[experimental\] Catching errors when dispatching [\#160](https://github.com/BendingSpoons/katana-swift/issues/160)
- Is there any co-currency management for a single store? [\#156](https://github.com/BendingSpoons/katana-swift/issues/156)
- Reduce boilerplate in Actions [\#155](https://github.com/BendingSpoons/katana-swift/issues/155)
- Are there any drawbacks to having a mutable store? [\#149](https://github.com/BendingSpoons/katana-swift/issues/149)

**Merged pull requests:**

- \[FEAT\] Prepare for release [\#168](https://github.com/BendingSpoons/katana-swift/pull/168) ([bolismauro](https://github.com/bolismauro))
- Fix dispatch retry [\#167](https://github.com/BendingSpoons/katana-swift/pull/167) ([fonesti](https://github.com/fonesti))
- Fix dispatch Promise resolved even if sideEffects throws [\#166](https://github.com/BendingSpoons/katana-swift/pull/166) ([fonesti](https://github.com/fonesti))
- Fix ObserverInterceptor items executed more than once [\#165](https://github.com/BendingSpoons/katana-swift/pull/165) ([fonesti](https://github.com/fonesti))
- Experimental logger [\#162](https://github.com/BendingSpoons/katana-swift/pull/162) ([bolismauro](https://github.com/bolismauro))
- \[FIX\] english [\#158](https://github.com/BendingSpoons/katana-swift/pull/158) ([TheInkedEngineer](https://github.com/TheInkedEngineer))
- Experimental guidelines changes proposal [\#157](https://github.com/BendingSpoons/katana-swift/pull/157) ([lucaquerella](https://github.com/lucaquerella))

## [2.0.0](https://github.com/BendingSpoons/katana-swift/tree/2.0.0) (2018-09-18)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/1.1.1...2.0.0)

**Closed issues:**

- Interface Builder [\#150](https://github.com/BendingSpoons/katana-swift/issues/150)

**Merged pull requests:**

- Swift 4.2 [\#153](https://github.com/BendingSpoons/katana-swift/pull/153) ([smaramba](https://github.com/smaramba))
- Fix/comments [\#152](https://github.com/BendingSpoons/katana-swift/pull/152) ([alextosatto](https://github.com/alextosatto))
- Feature/action logger [\#151](https://github.com/BendingSpoons/katana-swift/pull/151) ([alextosatto](https://github.com/alextosatto))

## [1.1.1](https://github.com/BendingSpoons/katana-swift/tree/1.1.1) (2018-07-03)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/1.1.0...1.1.1)

## [1.1.0](https://github.com/BendingSpoons/katana-swift/tree/1.1.0) (2018-07-03)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.13...1.1.0)

**Merged pull requests:**

- Add store initializer [\#147](https://github.com/BendingSpoons/katana-swift/pull/147) ([bolismauro](https://github.com/bolismauro))

## [0.8.13](https://github.com/BendingSpoons/katana-swift/tree/0.8.13) (2018-04-11)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/1.0.0...0.8.13)

**Closed issues:**

- Dead links in README [\#140](https://github.com/BendingSpoons/katana-swift/issues/140)
- Fail carthage build [\#137](https://github.com/BendingSpoons/katana-swift/issues/137)
- EdgeInsets for Vertical and Horizonal Layout Methods Are Misleading [\#101](https://github.com/BendingSpoons/katana-swift/issues/101)
- Tests are broken with iPhone5 [\#84](https://github.com/BendingSpoons/katana-swift/issues/84)
- Node DSL [\#69](https://github.com/BendingSpoons/katana-swift/issues/69)
- Change The Reference Size \(e.g. According to Device Orientation\) [\#67](https://github.com/BendingSpoons/katana-swift/issues/67)
- Add an example about wrapping Apple view controllers [\#66](https://github.com/BendingSpoons/katana-swift/issues/66)
- Define and implement a fully declarative Table and Grid [\#51](https://github.com/BendingSpoons/katana-swift/issues/51)
- \[Documentation\] Issue in UIKit classes extension [\#36](https://github.com/BendingSpoons/katana-swift/issues/36)

**Merged pull requests:**

- Fix/typos [\#146](https://github.com/BendingSpoons/katana-swift/pull/146) ([smaramba](https://github.com/smaramba))
- Update documentation [\#145](https://github.com/BendingSpoons/katana-swift/pull/145) ([smaramba](https://github.com/smaramba))
- Update docs [\#144](https://github.com/BendingSpoons/katana-swift/pull/144) ([smaramba](https://github.com/smaramba))
- Move Assets dir under .github [\#143](https://github.com/BendingSpoons/katana-swift/pull/143) ([smaramba](https://github.com/smaramba))
- Update UI section of readme [\#142](https://github.com/BendingSpoons/katana-swift/pull/142) ([smaramba](https://github.com/smaramba))
- Fix Tempura reference [\#141](https://github.com/BendingSpoons/katana-swift/pull/141) ([smaramba](https://github.com/smaramba))

## [1.0.0](https://github.com/BendingSpoons/katana-swift/tree/1.0.0) (2018-02-21)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.12...1.0.0)

**Merged pull requests:**

- UI separation [\#139](https://github.com/BendingSpoons/katana-swift/pull/139) ([bolismauro](https://github.com/bolismauro))

## [0.8.12](https://github.com/BendingSpoons/katana-swift/tree/0.8.12) (2017-09-26)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.11...0.8.12)

## [0.8.11](https://github.com/BendingSpoons/katana-swift/tree/0.8.11) (2017-09-26)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.10...0.8.11)

**Closed issues:**

- undefined is not an object \(evaluting 'Proptypes.number'\) [\#133](https://github.com/BendingSpoons/katana-swift/issues/133)

**Merged pull requests:**

- Update to Swift 4 [\#136](https://github.com/BendingSpoons/katana-swift/pull/136) ([smaramba](https://github.com/smaramba))

## [0.8.10](https://github.com/BendingSpoons/katana-swift/tree/0.8.10) (2017-07-31)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.9...0.8.10)

**Merged pull requests:**

- Expose Store dependencies as public [\#132](https://github.com/BendingSpoons/katana-swift/pull/132) ([smaramba](https://github.com/smaramba))

## [0.8.9](https://github.com/BendingSpoons/katana-swift/tree/0.8.9) (2017-07-24)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.8...0.8.9)

**Merged pull requests:**

- Fix the removal of a listener of the state [\#131](https://github.com/BendingSpoons/katana-swift/pull/131) ([smaramba](https://github.com/smaramba))

## [0.8.8](https://github.com/BendingSpoons/katana-swift/tree/0.8.8) (2017-07-18)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.7...0.8.8)

## [0.8.7](https://github.com/BendingSpoons/katana-swift/tree/0.8.7) (2017-07-18)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.6...0.8.7)

**Merged pull requests:**

- Fix `shouldUpdate` check [\#129](https://github.com/BendingSpoons/katana-swift/pull/129) ([valeriovolpe](https://github.com/valeriovolpe))

## [0.8.6](https://github.com/BendingSpoons/katana-swift/tree/0.8.6) (2017-06-12)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.5...0.8.6)

**Merged pull requests:**

- Fix Connect Wrong Behaviour [\#128](https://github.com/BendingSpoons/katana-swift/pull/128) ([bolismauro](https://github.com/bolismauro))

## [0.8.5](https://github.com/BendingSpoons/katana-swift/tree/0.8.5) (2017-05-30)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.4...0.8.5)

## [0.8.4](https://github.com/BendingSpoons/katana-swift/tree/0.8.4) (2017-05-25)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.3...0.8.4)

**Closed issues:**

- Managed children of native view don't update correctly in collectionviews [\#113](https://github.com/BendingSpoons/katana-swift/issues/113)
- Elements are not correctly reused [\#96](https://github.com/BendingSpoons/katana-swift/issues/96)

**Merged pull requests:**

- Remove performWithoutAnimation [\#127](https://github.com/BendingSpoons/katana-swift/pull/127) ([smaramba](https://github.com/smaramba))
- Add properties do `AnyNode` [\#126](https://github.com/BendingSpoons/katana-swift/pull/126) ([valeriovolpe](https://github.com/valeriovolpe))
- Fix Renderer’s `explore` [\#125](https://github.com/BendingSpoons/katana-swift/pull/125) ([valeriovolpe](https://github.com/valeriovolpe))

## [0.8.3](https://github.com/BendingSpoons/katana-swift/tree/0.8.3) (2017-05-11)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.2...0.8.3)

**Closed issues:**

- Katana Refs [\#121](https://github.com/BendingSpoons/katana-swift/issues/121)

**Merged pull requests:**

- Improves rendering performances [\#124](https://github.com/BendingSpoons/katana-swift/pull/124) ([bolismauro](https://github.com/bolismauro))
- Use XCake [\#123](https://github.com/BendingSpoons/katana-swift/pull/123) ([bolismauro](https://github.com/bolismauro))

## [0.8.2](https://github.com/BendingSpoons/katana-swift/tree/0.8.2) (2017-04-19)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.1...0.8.2)

**Closed issues:**

- Improve state mocking [\#111](https://github.com/BendingSpoons/katana-swift/issues/111)

**Merged pull requests:**

- Add Refs [\#122](https://github.com/BendingSpoons/katana-swift/pull/122) ([bolismauro](https://github.com/bolismauro))

## [0.8.1](https://github.com/BendingSpoons/katana-swift/tree/0.8.1) (2017-04-11)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.8.0...0.8.1)

**Closed issues:**

- Store queue management should be refactored [\#118](https://github.com/BendingSpoons/katana-swift/issues/118)

## [0.8.0](https://github.com/BendingSpoons/katana-swift/tree/0.8.0) (2017-04-08)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.8...0.8.0)

**Merged pull requests:**

- Refactor internal action management in store [\#120](https://github.com/BendingSpoons/katana-swift/pull/120) ([bolismauro](https://github.com/bolismauro))
- State Mock Feature [\#114](https://github.com/BendingSpoons/katana-swift/pull/114) ([bolismauro](https://github.com/bolismauro))

## [0.7.8](https://github.com/BendingSpoons/katana-swift/tree/0.7.8) (2017-04-06)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.6...0.7.8)

**Merged pull requests:**

- Fix Store Dispatch [\#119](https://github.com/BendingSpoons/katana-swift/pull/119) ([sroddy](https://github.com/sroddy))

## [0.7.6](https://github.com/BendingSpoons/katana-swift/tree/0.7.6) (2017-04-05)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.5...0.7.6)

**Merged pull requests:**

- Fix store state dependencies [\#117](https://github.com/BendingSpoons/katana-swift/pull/117) ([AlfioRusso](https://github.com/AlfioRusso))

## [0.7.5](https://github.com/BendingSpoons/katana-swift/tree/0.7.5) (2017-04-05)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.4...0.7.5)

**Closed issues:**

- Readme outdated [\#105](https://github.com/BendingSpoons/katana-swift/issues/105)

**Merged pull requests:**

- Fix/store dispatch [\#116](https://github.com/BendingSpoons/katana-swift/pull/116) ([AlfioRusso](https://github.com/AlfioRusso))
- Fix Plastic top [\#115](https://github.com/BendingSpoons/katana-swift/pull/115) ([sroddy](https://github.com/sroddy))
- Fix typo in comment [\#112](https://github.com/BendingSpoons/katana-swift/pull/112) ([mickeyreiss](https://github.com/mickeyreiss))

## [0.7.4](https://github.com/BendingSpoons/katana-swift/tree/0.7.4) (2017-03-14)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.3...0.7.4)

## [0.7.3](https://github.com/BendingSpoons/katana-swift/tree/0.7.3) (2017-03-13)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.2...0.7.3)

**Closed issues:**

- Action callback should be optional [\#106](https://github.com/BendingSpoons/katana-swift/issues/106)

**Merged pull requests:**

- Fix Table Example [\#110](https://github.com/BendingSpoons/katana-swift/pull/110) ([darrarski](https://github.com/darrarski))
- Expose `borderColor` and `borderWidth` on Button [\#109](https://github.com/BendingSpoons/katana-swift/pull/109) ([valeriovolpe](https://github.com/valeriovolpe))
- Optional inouts [\#108](https://github.com/BendingSpoons/katana-swift/pull/108) ([bolismauro](https://github.com/bolismauro))

## [0.7.2](https://github.com/BendingSpoons/katana-swift/tree/0.7.2) (2017-02-12)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.1...0.7.2)

## [0.7.1](https://github.com/BendingSpoons/katana-swift/tree/0.7.1) (2017-02-12)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.7.0...0.7.1)

## [0.7.0](https://github.com/BendingSpoons/katana-swift/tree/0.7.0) (2017-02-07)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.6.1...0.7.0)

**Merged pull requests:**

- Side effects refactor [\#107](https://github.com/BendingSpoons/katana-swift/pull/107) ([bolismauro](https://github.com/bolismauro))

## [0.6.1](https://github.com/BendingSpoons/katana-swift/tree/0.6.1) (2017-01-31)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.6.0...0.6.1)

**Implemented enhancements:**

- SyncAction/AsyncAction should be improved [\#99](https://github.com/BendingSpoons/katana-swift/issues/99)

## [0.6.0](https://github.com/BendingSpoons/katana-swift/tree/0.6.0) (2017-01-27)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.5.2...0.6.0)

**Merged pull requests:**

- Release 0.6.0 [\#104](https://github.com/BendingSpoons/katana-swift/pull/104) ([bolismauro](https://github.com/bolismauro))
- Feature/new actions [\#103](https://github.com/BendingSpoons/katana-swift/pull/103) ([bolismauro](https://github.com/bolismauro))

## [0.5.2](https://github.com/BendingSpoons/katana-swift/tree/0.5.2) (2017-01-17)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.5.1...0.5.2)

**Merged pull requests:**

- Make the ActionLinks init public [\#102](https://github.com/BendingSpoons/katana-swift/pull/102) ([cipolleschi](https://github.com/cipolleschi))

## [0.5.1](https://github.com/BendingSpoons/katana-swift/tree/0.5.1) (2017-01-16)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.5.0...0.5.1)

## [0.5.0](https://github.com/BendingSpoons/katana-swift/tree/0.5.0) (2017-01-13)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.4.0...0.5.0)

**Merged pull requests:**

- Release 0.5.0 [\#100](https://github.com/BendingSpoons/katana-swift/pull/100) ([bolismauro](https://github.com/bolismauro))
- Feature/action linker [\#98](https://github.com/BendingSpoons/katana-swift/pull/98) ([cipolleschi](https://github.com/cipolleschi))
- Make PlasticView scaleValue public [\#97](https://github.com/BendingSpoons/katana-swift/pull/97) ([sroddy](https://github.com/sroddy))
- Improve lifecycle api [\#95](https://github.com/BendingSpoons/katana-swift/pull/95) ([bolismauro](https://github.com/bolismauro))

## [0.4.0](https://github.com/BendingSpoons/katana-swift/tree/0.4.0) (2016-12-24)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.3.0...0.4.0)

**Closed issues:**

- Lifecycle API [\#89](https://github.com/BendingSpoons/katana-swift/issues/89)
- Middleware cannot be shared [\#87](https://github.com/BendingSpoons/katana-swift/issues/87)
- \[Renaming\] Middlewares is not correct english [\#86](https://github.com/BendingSpoons/katana-swift/issues/86)
- Cocoapods Instructions for MacOS are missing [\#85](https://github.com/BendingSpoons/katana-swift/issues/85)
- Reducers? [\#81](https://github.com/BendingSpoons/katana-swift/issues/81)
- Implement a simple Hacker News reader as an example [\#54](https://github.com/BendingSpoons/katana-swift/issues/54)

**Merged pull requests:**

- Develop [\#94](https://github.com/BendingSpoons/katana-swift/pull/94) ([bolismauro](https://github.com/bolismauro))
- Update swiftlint [\#93](https://github.com/BendingSpoons/katana-swift/pull/93) ([bolismauro](https://github.com/bolismauro))
- Feature/refactor middleware [\#92](https://github.com/BendingSpoons/katana-swift/pull/92) ([bolismauro](https://github.com/bolismauro))
- Random Int generation fix [\#91](https://github.com/BendingSpoons/katana-swift/pull/91) ([untakatapuntaka](https://github.com/untakatapuntaka))
- Lifecycle APIs [\#90](https://github.com/BendingSpoons/katana-swift/pull/90) ([bolismauro](https://github.com/bolismauro))
- Update SyncAction.swift documentation [\#88](https://github.com/BendingSpoons/katana-swift/pull/88) ([frankdilo](https://github.com/frankdilo))

## [0.3.0](https://github.com/BendingSpoons/katana-swift/tree/0.3.0) (2016-11-29)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.2.0...0.3.0)

**Closed issues:**

- \[Readme\] Existing project integration  [\#79](https://github.com/BendingSpoons/katana-swift/issues/79)
- The fill method of PlasticView is ambiguously named [\#77](https://github.com/BendingSpoons/katana-swift/issues/77)
- 0.2.0 Release [\#70](https://github.com/BendingSpoons/katana-swift/issues/70)
- Add support for CocoaPods and Carthage [\#47](https://github.com/BendingSpoons/katana-swift/issues/47)

**Merged pull requests:**

- Add fit method to PlastcView [\#83](https://github.com/BendingSpoons/katana-swift/pull/83) ([marcopaz](https://github.com/marcopaz))
- Add gradual adoption to README [\#80](https://github.com/BendingSpoons/katana-swift/pull/80) ([bolismauro](https://github.com/bolismauro))
- Fix Typo In Renaming [\#78](https://github.com/BendingSpoons/katana-swift/pull/78) ([sroddy](https://github.com/sroddy))
- DSL for PlasticView Anchors and Values [\#76](https://github.com/BendingSpoons/katana-swift/pull/76) ([madbat](https://github.com/madbat))
- Update missing code hightlight [\#75](https://github.com/BendingSpoons/katana-swift/pull/75) ([zld](https://github.com/zld))
- Katana for macOS [\#74](https://github.com/BendingSpoons/katana-swift/pull/74) ([smaramba](https://github.com/smaramba))
- Add .idea to .gitignore [\#73](https://github.com/BendingSpoons/katana-swift/pull/73) ([sroddy](https://github.com/sroddy))
- Update documentation [\#72](https://github.com/BendingSpoons/katana-swift/pull/72) ([ParideBifulco](https://github.com/ParideBifulco))
- Move rename and fix header of Int+Katana.swift [\#71](https://github.com/BendingSpoons/katana-swift/pull/71) ([lucaquerella](https://github.com/lucaquerella))

## [0.2.0](https://github.com/BendingSpoons/katana-swift/tree/0.2.0) (2016-11-17)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.1.0...0.2.0)

**Closed issues:**

- Ensure pod try works [\#59](https://github.com/BendingSpoons/katana-swift/issues/59)

**Merged pull requests:**

- Update Action.updateRenderer to be an instance method [\#68](https://github.com/BendingSpoons/katana-swift/pull/68) ([smaramba](https://github.com/smaramba))
- Fix the access to the renderer from every node [\#65](https://github.com/BendingSpoons/katana-swift/pull/65) ([smaramba](https://github.com/smaramba))

## [0.1.0](https://github.com/BendingSpoons/katana-swift/tree/0.1.0) (2016-11-15)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.0.2...0.1.0)

**Fixed bugs:**

- Async Action: side effect is called also for completed and failed state [\#40](https://github.com/BendingSpoons/katana-swift/issues/40)

**Closed issues:**

- Force Swiftlint Version [\#62](https://github.com/BendingSpoons/katana-swift/issues/62)
- update minefield example project and put a link to it in the README [\#52](https://github.com/BendingSpoons/katana-swift/issues/52)
- Find and add a license [\#48](https://github.com/BendingSpoons/katana-swift/issues/48)
- Add default implementation of isEqual to the table delegate [\#44](https://github.com/BendingSpoons/katana-swift/issues/44)
- PlasticNodeDescriptionWithReference size should implement the PlasticNodeDescription protocol [\#43](https://github.com/BendingSpoons/katana-swift/issues/43)
- Write LICENSE.md and link to the README.md [\#42](https://github.com/BendingSpoons/katana-swift/issues/42)
- Write a CONTRIBUTE.md file and link it to the README.md [\#41](https://github.com/BendingSpoons/katana-swift/issues/41)
- Add alpha in props [\#39](https://github.com/BendingSpoons/katana-swift/issues/39)
- Refactor animations [\#35](https://github.com/BendingSpoons/katana-swift/issues/35)
- Write a simple example [\#34](https://github.com/BendingSpoons/katana-swift/issues/34)
- Review Documentation [\#33](https://github.com/BendingSpoons/katana-swift/issues/33)
- Node root and treeRoot confusion [\#31](https://github.com/BendingSpoons/katana-swift/issues/31)
- Root init method and `node` var [\#29](https://github.com/BendingSpoons/katana-swift/issues/29)
- Store unsubscribe in `Root` [\#28](https://github.com/BendingSpoons/katana-swift/issues/28)
- Node draw method should not be public [\#26](https://github.com/BendingSpoons/katana-swift/issues/26)
- Refactor Node init [\#25](https://github.com/BendingSpoons/katana-swift/issues/25)
- Probably unnecessary throw [\#24](https://github.com/BendingSpoons/katana-swift/issues/24)
- Remove "extra" from katana \(e.g., UIColor category\) [\#22](https://github.com/BendingSpoons/katana-swift/issues/22)
- Write a great README [\#21](https://github.com/BendingSpoons/katana-swift/issues/21)
- Write documentation [\#20](https://github.com/BendingSpoons/katana-swift/issues/20)
- Create base UI elements  [\#18](https://github.com/BendingSpoons/katana-swift/issues/18)
- Refactor how props chaining is implemented [\#16](https://github.com/BendingSpoons/katana-swift/issues/16)
- Update project to respect Swift 3 naming conventions and improve clarity [\#15](https://github.com/BendingSpoons/katana-swift/issues/15)
- Create a great logo [\#13](https://github.com/BendingSpoons/katana-swift/issues/13)
- Fix warnings on the project [\#12](https://github.com/BendingSpoons/katana-swift/issues/12)
- Add support for external libraries with actions [\#11](https://github.com/BendingSpoons/katana-swift/issues/11)
- Refactor action system [\#10](https://github.com/BendingSpoons/katana-swift/issues/10)
- Fix the "synchronous update" bug [\#9](https://github.com/BendingSpoons/katana-swift/issues/9)

**Merged pull requests:**

- Update to new swiftlint [\#63](https://github.com/BendingSpoons/katana-swift/pull/63) ([bolismauro](https://github.com/bolismauro))
- Update README.md [\#61](https://github.com/BendingSpoons/katana-swift/pull/61) ([sroddy](https://github.com/sroddy))
- Minesweeper Demo [\#60](https://github.com/BendingSpoons/katana-swift/pull/60) ([smaramba](https://github.com/smaramba))
- Add Xcode snippets [\#58](https://github.com/BendingSpoons/katana-swift/pull/58) ([bolismauro](https://github.com/bolismauro))
- Update README.md [\#57](https://github.com/BendingSpoons/katana-swift/pull/57) ([madbat](https://github.com/madbat))
- Add namespace for Katana Elements propertie structs [\#56](https://github.com/BendingSpoons/katana-swift/pull/56) ([bolismauro](https://github.com/bolismauro))
- Add CONTRIBUTING file [\#55](https://github.com/BendingSpoons/katana-swift/pull/55) ([bolismauro](https://github.com/bolismauro))
- Feature/animation demo [\#53](https://github.com/BendingSpoons/katana-swift/pull/53) ([bolismauro](https://github.com/bolismauro))
- Feature/license [\#50](https://github.com/BendingSpoons/katana-swift/pull/50) ([bolismauro](https://github.com/bolismauro))
- Fix \#40 [\#49](https://github.com/BendingSpoons/katana-swift/pull/49) ([bolismauro](https://github.com/bolismauro))
- Demo thecodinglove [\#46](https://github.com/BendingSpoons/katana-swift/pull/46) ([alaincaltieri](https://github.com/alaincaltieri))
- Node root and treeRoot confusion [\#45](https://github.com/BendingSpoons/katana-swift/pull/45) ([smaramba](https://github.com/smaramba))
- Refactor Animations [\#38](https://github.com/BendingSpoons/katana-swift/pull/38) ([bolismauro](https://github.com/bolismauro))
- Fix/proofread documentation [\#37](https://github.com/BendingSpoons/katana-swift/pull/37) ([Luca-Papale](https://github.com/Luca-Papale))
- Improve Node init [\#32](https://github.com/BendingSpoons/katana-swift/pull/32) ([lucaquerella](https://github.com/lucaquerella))
- Create README.md [\#30](https://github.com/BendingSpoons/katana-swift/pull/30) ([smaramba](https://github.com/smaramba))
- Feature/documentation [\#27](https://github.com/BendingSpoons/katana-swift/pull/27) ([bolismauro](https://github.com/bolismauro))
- Fix/renaming [\#23](https://github.com/BendingSpoons/katana-swift/pull/23) ([smaramba](https://github.com/smaramba))
- Elements Reworking [\#19](https://github.com/BendingSpoons/katana-swift/pull/19) ([bolismauro](https://github.com/bolismauro))
- Feature/new actions [\#17](https://github.com/BendingSpoons/katana-swift/pull/17) ([bolismauro](https://github.com/bolismauro))
- Fix/update bug [\#14](https://github.com/BendingSpoons/katana-swift/pull/14) ([bolismauro](https://github.com/bolismauro))

## [0.0.2](https://github.com/BendingSpoons/katana-swift/tree/0.0.2) (2016-10-24)
[Full Changelog](https://github.com/BendingSpoons/katana-swift/compare/0.0.1...0.0.2)

## [0.0.1](https://github.com/BendingSpoons/katana-swift/tree/0.0.1) (2016-10-10)
**Closed issues:**

- Moved [\#6](https://github.com/BendingSpoons/katana-swift/issues/6)

**Merged pull requests:**

- Feature grid [\#5](https://github.com/BendingSpoons/katana-swift/pull/5) ([bolismauro](https://github.com/bolismauro))
- Feature Table [\#4](https://github.com/BendingSpoons/katana-swift/pull/4) ([bolismauro](https://github.com/bolismauro))
- Katana storage integration [\#3](https://github.com/BendingSpoons/katana-swift/pull/3) ([bolismauro](https://github.com/bolismauro))
- Children refactor [\#2](https://github.com/BendingSpoons/katana-swift/pull/2) ([bolismauro](https://github.com/bolismauro))
- \[WIP\] Plastic Integration in Katana [\#1](https://github.com/BendingSpoons/katana-swift/pull/1) ([bolismauro](https://github.com/bolismauro))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
