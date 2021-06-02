#
# Be sure to run `pod lib lint TonNfcClientSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TonNfcClientSwift'
  s.version          = '0.1.0'
  s.summary          = 'This is a library to work with TON NFC security cards.'
  s.description      = 'This library provides functions allowing to make all available TON NFC cards operations.'

  s.homepage         = 'https://github.com/tonlabs/TonNfcClientSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tonlabs' => 'alina.t@tonlabs.io' }
  s.source           = { :git => 'https://github.com/tonlabs/TonNfcClientSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  
  s.platforms    = { :ios => "11.0" }

  s.source_files = 'TonNfcClientSwift/Classes/**/*'
  
  s.swift_version = '5.0'
  
  s.dependency "PromiseKit", "~> 6.8"
  
  # s.resource_bundles = {
  #   'TonNfcClientSwift' => ['TonNfcClientSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
