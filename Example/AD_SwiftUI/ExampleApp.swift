//
//  AD_SwiftUIApp.swift
//  AD_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import UIKit
#if canImport(TradPlusAds)
import TradPlusAds
import AD_SwiftUI
#endif
import AdSupport
import AppTrackingTransparency
@main
struct ExampleApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var shownSlashAD = false
    var body: some Scene {
        WindowGroup {
            ZStack{
                
                ContentView()
                    .adSplash(adUnitID: "A118974AE60B857E149350ED681FF1B5") {
                        print("启动广告关闭,打开内购页面")
                    }
//                if !shownSlashAD{
//                    ADSplashView(shownAD: $shownSlashAD, adUnitID: "A118974AE60B857E149350ED681FF1B5")
//                }
            }
            .checkADTracking()
        
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ADManager.initTradPlusAds("CF8D49752B1D34720A7C93D9B98BFAE4")
        
        return true
    }
    
}
