#
# Be sure to run `pod lib lint DGCNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DGCNetWork'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DGCNetWork.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/admin/DGCNetWork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'admin' => 'huan.xin@renrengame.com' }
  s.source           = { :git => 'https://github.com/wangweiqi864-hue/DGCNetWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'DGCNetWork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DGCNetWork' => ['DGCNetWork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'Alamofire'
  s.dependency 'CocoaAsyncSocket'
  s.dependency 'DGCLog' # 需要在Podfile 先导入
  s.dependency 'SwiftProtobuf', '~> 1.25.2'
  s.dependency 'KeychainAccess','~> 4.2.2'
  s.dependency 'Starscream'
  s.dependency 'YYCache' , '~> 1.0.4'
  
  s.dependency 'PointEvent'
end
