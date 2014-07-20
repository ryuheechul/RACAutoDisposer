#
# Be sure to run `pod lib lint RACAutoDisposer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RACAutoDisposer"
  s.version          = "0.1.0"
  s.summary          = "Dispose RACSubscriptions with an easy way"
  s.homepage         = "https://github.com/ryuheechul/RACAutoDisposer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ryu Heechul" => "ryuhcii@gmail.com" }
  s.source           = { :git => "https://github.com/ryuheechul/RACAutoDisposer.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ryuheechul'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ReactiveCocoa'
end
