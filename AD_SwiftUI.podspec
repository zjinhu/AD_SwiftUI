#
# Be sure to run `pod lib lint AD_SwiftUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AD_SwiftUI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AD_SwiftUI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/AD_SwiftUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jackiehu' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/AD_SwiftUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = "15.0"
  s.swift_versions     = ['5.5','5.4','5.9','5.8','5.7','5.6']
  s.requires_arc = true
  s.static_framework = true
  s.frameworks   = 'SystemConfiguration','CoreGraphics','Foundation','UIKit','DeviceCheck',"SwiftUI","AppTrackingTransparency","JavaScriptCore","CoreLocation","CoreImage","Accelerate","EventKit","EventKitUI"
  
  s.libraries = 'c++','z','sqlite3','xml2','resolv','bz2'
#  s.default_subspecs = 'Manager'
  #文件路径
  s.subspec 'Banner' do |ss|
    ss.dependency 'AD_SwiftUI/Manager'
    ss.source_files = 'Sources/AD_SwiftUI/ADBannerView.swift'
  end
  s.subspec 'Inter' do |ss|
    ss.dependency 'AD_SwiftUI/Manager'
    ss.source_files = 'Sources/AD_SwiftUI/ADInterView.swift'
  end
  s.subspec 'Reward' do |ss|
    ss.dependency 'AD_SwiftUI/Manager'
    ss.source_files = 'Sources/AD_SwiftUI/ADRewardView.swift'
  end
  s.subspec 'Splash' do |ss|
    ss.dependency 'AD_SwiftUI/Manager'
    ss.source_files = 'Sources/AD_SwiftUI/ADSplashView.swift'
  end
  s.subspec 'Manager' do |ss|
    ss.source_files = 'Sources/AD_SwiftUI/ADManager.swift'
  end
  
  s.dependency 'TradPlusAdSDK', '9.7.0'

end
