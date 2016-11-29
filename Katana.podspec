Pod::Spec.new do |s|
  s.name             = 'Katana'
  s.version          = File.read(".version")
  s.summary          = 'Swift Apps in a swoosh'


  s.description      = <<-DESC

Katana is a modern Swift framework for writing iOS apps, strongly inspired by [React](https://facebook.github.io/react/) and [Redux](http://redux.js.org/), that gives structure to all the aspects of your app:

- __logic__: the app state is entirely described by a single serializable data structure, and the only way to change the state is to dispatch an action. An action is an intent to transform the state, and contains all the information to do so. Because all the changes are centralized and are happening in a strict order, there are no subtle race conditions to watch out for.
- __UI__: the UI is defined in terms of a tree of components declaratively described by props (the configuration data, i.e. a background color for a button) and state (the internal state data, i.e. the highlighted state for a button). This approach lets you think about components as isolated, reusable pieces of UI, since the way a component is rendered only depends on the current props and state of the component itself.
- __logic__ ↔️ __UI__: the UI components are connected to the app state and will be automatically updated on every state change. You control how they change, selecting the portion of app state that will feed the component props. To render this process as fast as possible, only the relevant portion of the UI is updated. 
- __layout__: Katana defines a concise language (inspired by [Plastic](https://github.com/BendingSpoons/plastic-lib-iOS)) to describe fully responsive layouts that will gracefully scale at every aspect ratio or size, including font sizes and images.

We feel that Katana helped us a lot since we started using it in production. At [Bending Spoons](http://www.bendingspoons.com) we use a lot of open source projects ourselves and we wanted to give something back to the community, hoping you will find this useful and possibly contribute. ❤️ 

                       DESC


  s.homepage         = 'https://github.com/BendingSpoons/katana-swift.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bending Spoons' => 'team@bendingspoons.com' }
  s.source           = { :git => 'https://github.com/BendingSpoons/katana-swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/katana_swift'

  s.ios.deployment_target = '8.3'
  s.osx.deployment_target = '10.10'
  
  s.source_files = ['Katana/**/*.{swift,h}']
  
  s.ios.exclude_files = 'Katana/macOS/**/*'
  s.osx.exclude_files = 'Katana/iOS/**/*'
  
end
