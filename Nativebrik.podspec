Pod::Spec.new do |s|
  s.name             = 'Nativebrik'
  s.version          = '0.1.5'
  s.summary          = 'Nativebrik SDK'
  s.description      = <<-DESC
Nativebrik SDK for iOS.
                       DESC

  s.homepage         = 'https://nativebrik.com'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'Nativebrik' => 'dev.share+nativebrik@plaid.co.jp' }
  s.source           = { :git => 'https://github.com/plaidev/nativebrik-sdk.git', :tag => 'v' + s.version.to_s }

  s.swift_version = '5'
  s.ios.deployment_target = '16.2'

  s.source_files = 'ios/Nativebrik/Classes/**/*'

  s.frameworks = 'UIKit', 'Foundation', 'SwiftUI', 'Combine'
  s.dependency 'YogaKit', '~> 1.18'
end
