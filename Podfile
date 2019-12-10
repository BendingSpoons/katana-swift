# Uncomment the next line to define a global platform for your project
platform :ios, '8.3'
inhibit_all_warnings!

target 'Katana' do
  use_frameworks!

  podspec

  target 'KatanaTests' do
    inherit! :search_paths
    
    pod 'Quick', '~> 1.3'
    pod 'Nimble', '~> 7.3'
    pod 'HydraAsync', '~> 2.0'
  end
end

