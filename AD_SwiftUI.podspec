
Pod::Spec.new do |s|
  s.name             = 'AD_SwiftUI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AD_SwiftUI.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/AD_SwiftUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jackiehu' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/AD_SwiftUI.git', :tag => s.version.to_s }

  s.ios.deployment_target = "15.0"
  s.swift_versions     = ['5.5','5.4','5.9','5.8','5.7','5.6']
  s.requires_arc = true
  s.static_framework = true
  s.frameworks   = 'SystemConfiguration','CoreGraphics','Foundation','UIKit','DeviceCheck',"SwiftUI","AppTrackingTransparency","JavaScriptCore","CoreLocation","CoreImage","Accelerate","EventKit","EventKitUI"
  
  s.libraries = 'c++','z','sqlite3','xml2','resolv','bz2'
  s.user_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
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
 
s.dependency 'TradPlusAdSDK', '9.9.0'
s.dependency 'TradPlusAdSDK/AdMobAdapter', '9.9.0'
s.dependency 'Google-Mobile-Ads-SDK','10.10.0'
s.dependency 'TradPlusAdSDK/MintegralAdapter', '9.9.0'
s.dependency 'MintegralAdSDK' ,'7.4.3'
s.dependency 'MintegralAdSDK/All','7.4.3'
s.dependency 'TradPlusAdSDK/TPCrossAdapter', '9.9.0'

end
