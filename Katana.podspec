Pod::Spec.new do |s|
  s.name             = 'Katana'
  s.version          = File.read(".version")
  s.summary          = 'Swift Apps in a swoosh'


  s.description      = <<-DESC

  Katana is a modern Swift framework for writing iOS applications business logic that are testable and easy to reason about. Katana is strongly inspired by [Redux](http://redux.js.org/).

  In few words, the app state is entirely described by a single serializable data structure, and the only way to change the state is to dispatch an action. An action is an intent to transform the state, and contains all the information to do so. Because all the changes are centralized and are happening in a strict order, there are no subtle race conditions to watch out for.
  
  We feel that Katana helped us a lot since we started using it in production. Our applications have been downloaded several milions of times and Katana really helped us scaling them quickly and efficiently. [Bending Spoons](http://www.bendingspoons.com)'s engineers leverage Katana capabilities to design, implement and test complex applications very quickly without any compromise to the final result. 
  
  We use a lot of open source projects ourselves and we wanted to give something back to the community, hoping you will find this useful and possibly contribute. ❤️ 
                       DESC


  s.homepage         = 'https://github.com/BendingSpoons/katana-swift.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bending Spoons' => 'team@bendingspoons.com' }
  s.source           = { :git => 'https://github.com/BendingSpoons/katana-swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/katana_swift'

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target  = '10.10'
  s.swift_version = '5.0'
  s.source_files = ['Sources/**/*.{swift,h}']

  s.dependency 'HydraAsync', '>= 2.0.6', '< 3'
end
