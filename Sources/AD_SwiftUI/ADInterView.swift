//
//  SplashADView.swift
//  Eraser
//
//  Created by 狄烨 on 2023/8/4.
//

import SwiftUI
#if canImport(TradPlusAds)
import TradPlusAds

extension View {
    @ViewBuilder
    public func adInter(adUnitID: String) -> some View {
        if !UserDefaults.standard.bool(forKey: "isPro.InPurchase"){
            modifier(ADInterModifier(adUnitID: adUnitID))
        }
    }
}

public struct ADInterModifier: ViewModifier {

    private let adInstanse : InterInstance?

    public init(adUnitID: String) {
        adInstanse = InterInstance(adUnitID: adUnitID)
        adInstanse?.loadAd()
    }

    public func body(content: Content) -> some View {
        content
            .onFirstAppear {
                adInstanse?.showAD()
            }
    }
}

public struct ADInterView: View {

    private let adUnitID: String
    private let adInstanse : InterInstance?

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
        adInstanse = InterInstance(adUnitID: adUnitID)
        adInstanse?.loadAd()
    }

    public var body: some View {
        VStack {
            Color.clear
        }
        .onFirstAppear {
            adInstanse?.showAD()
        }
    }
}

public class InterInstance: NSObject, TradPlusADInterstitialDelegate {
    private let adUnitID: String
    var adInstance: TradPlusAdInterstitial?

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    public func loadAd() {
        clean()
        adInstance = TradPlusAdInterstitial()
        adInstance?.setAdUnitID(adUnitID)
        adInstance?.delegate = self
        adInstance?.loadAd()
    }
    
    private func clean() {
        adInstance = nil
    }
 
    public func showAD(){
        
        if adInstance?.isAdReady == true{
            adInstance?.showAd(withSceneId: nil)
        }
    }
    
    public func tpInterstitialAdLoaded(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Inter AdLoaded")
    }
    
    public func tpInterstitialAdLoadFailWithError(_ error: Error) {
        debugPrint("Inter AdLoadFail")
    }
    
    public func tpInterstitialAdImpression(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Inter AdImpression")
    }
    
    public func tpInterstitialAdShow(_ adInfo: [AnyHashable : Any], didFailWithError error: Error) {
        debugPrint("Inter AdDidShow:Error\(error)")
    }
    
    public func tpInterstitialAdClicked(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Inter AdClicked")
    }
    
    public func tpInterstitialAdDismissed(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Inter AdDismissed")
        clean()
    }
    
}

#endif
