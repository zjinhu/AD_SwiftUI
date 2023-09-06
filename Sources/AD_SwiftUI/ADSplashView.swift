//
//  SplashAdView.swift
//  Eraser
//
//  Created by 狄烨 on 2023/8/4.
//

import SwiftUI
import UIKit
import Foundation
#if canImport(TradPlusAds)
import TradPlusAds

extension View {
    @ViewBuilder
    public func adSplash(adUnitID: String, perform action: @escaping () -> ()) -> some View {
        if !UserDefaults.standard.bool(forKey: "isPro.InPurchase"){
            modifier(ADSplashModifier(adUnitID: adUnitID, action: action))
        }else{
            self
        }
    }
}

public struct ADSplashModifier: ViewModifier,SlashADInstanceProtocol {
    public func closeAD() {
        action()
    }

    private var adInstanse: SplashAdInstance?
    private let action: () -> ()
    public init(adUnitID: String, action: @escaping () -> ()) {
        self.action = action
        adInstanse = SplashAdInstance(adUnitID: adUnitID)
        adInstanse?.delegate = self
    }

    public func body(content: Content) -> some View {
        content
            .onFirstAppear(){
                adInstanse?.loadAd()
            }
    }
}

public struct ADSplashView: View, SlashADInstanceProtocol{
    
    @Binding var shownAD: Bool
    
    private let adUnitID: String
    
    private let adInstanse : SplashAdInstance?
    
    public init(shownAD: Binding<Bool>, adUnitID: String) {
        self._shownAD = shownAD
        self.adUnitID = adUnitID
        adInstanse = SplashAdInstance(adUnitID: adUnitID)
        adInstanse?.delegate = self
    }
 
    public func closeAD() {
        shownAD = true
    }
 
    public var body: some View {
        VStack {
            Color.clear
        }
        .onFirstAppear {
            adInstanse?.loadAd()
        }
    }
}

public class SplashAdInstance: NSObject, TradPlusADSplashDelegate {
    
    var delegate: SlashADInstanceProtocol?
    var adInstance: TradPlusAdSplash?
    private let adUnitID: String
    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    private func clean() {
        adInstance = nil
    }
    
    public func loadAd() {
        clean()
        adInstance = TradPlusAdSplash()
        adInstance?.setAdUnitID(adUnitID)
        adInstance?.delegate = self
        if let window = UIWindow.keyWindow{
            adInstance?.loadAd(with: window, bottomView: nil)
        }
    }
    
    public func showAD(){
        if adInstance?.isAdReady == true{
            adInstance?.show()
        }
    }
    
    public func tpSplashAdLoaded(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Splash AdLoaded")
        showAD()
    }
    
    public func tpSplashAdLoadFailWithError(_ error: Error) {
        debugPrint("Splash AdLoadFail")
    }
    
    public func tpSplashAdImpression(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Splash AdImpression")
    }
    
    public func tpSplashAdShow(_ adInfo: [AnyHashable : Any], didFailWithError error: Error) {
        debugPrint("Splash AdDidShow:Error\(error)")
    }
    
    public func tpSplashAdClicked(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Splash AdClicked")
    }
    
    public func tpSplashAdDismissed(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Splash Dismissed")
        delegate?.closeAD()
        clean()
    }
}

public protocol SlashADInstanceProtocol {
    func closeAD()
}
#endif
