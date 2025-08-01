#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nativebrik_bridge.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nativebrik_bridge'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://nativebrik.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nativebrik Inc' => 'dev.share@nativebrik.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Nativebrik', '~> 0.10.2'
  s.ios.deployment_target = '14.0'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
