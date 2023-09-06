//
//  RewardADView.swift
//  Eraser
//
//  Created by 狄烨 on 2023/8/5.
//

import SwiftUI

#if canImport(TradPlusAds)
import TradPlusAds

extension View {
    @ViewBuilder
    public func adReward(adUnitID: String, perform action: @escaping () -> ()) -> some View {
        if !UserDefaults.standard.bool(forKey: "isPro.InPurchase"){
            modifier(ADRewardModifier(adUnitID: adUnitID, action: action))
        }else{
            self
        }
    }
}

public struct ADRewardModifier: ViewModifier,RewardADInstanceProtocol {
    public func getRewardedCount() {
        action()
    }

    private var adInstanse: ADRewardInstance?
    private let action: () -> ()
    public init(adUnitID: String, action: @escaping () -> ()) {
        self.action = action
        adInstanse = ADRewardInstance(adUnitID: adUnitID)
        adInstanse?.delegate = self
        
    }

    public func body(content: Content) -> some View {
        content
            .onAppear{
                adInstanse?.loadAd()
            }
            .onTapGesture {
                adInstanse?.showAD()
            }
    }
}

public class ADRewardInstance: NSObject, TradPlusADRewardedDelegate {

    public var delegate: RewardADInstanceProtocol?
    
    var adInstance: TradPlusAdRewarded?
    
    private let adUnitID: String
    
    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }
 
    private func clean() {
        adInstance = nil
    }
    
    public func loadAd() {
        clean()
        adInstance = TradPlusAdRewarded()
        adInstance?.setAdUnitID(adUnitID)
        adInstance?.delegate = self
        adInstance?.loadAd()
    }
    
    public func loadAd() async throws {
        clean()
        return try await withCheckedThrowingContinuation { continuation in
            adInstance = TradPlusAdRewarded()
            adInstance?.setAdUnitID(adUnitID)
            adInstance?.delegate = self
            adInstance?.loadAd()
        }
    }
    
    public func showAD(){
        if adInstance?.isAdReady == true{
            adInstance?.showAd(withSceneId: nil)
        }
    }
    
    public func tpRewardedAdLoaded(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Rewarded AdLoaded")
    }
    
    public func tpRewardedAdLoadFailWithError(_ error: Error) {
        debugPrint("Rewarded AdLoadFail")
    }
    
    public func tpRewardedAdImpression(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Rewarded AdImpression")
    }
    
    public func tpRewardedAdShow(_ adInfo: [AnyHashable : Any], didFailWithError error: Error) {
        debugPrint("Rewarded AdDidShow:Error\(error)")
    }
    
    public func tpRewardedAdClicked(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Rewarded AdClicked")
    }
    
    public func tpRewardedAdDismissed(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Rewarded AdDismissed")
        clean()
    }
    
    public func tpRewardedAdReward(_ adInfo: [AnyHashable : Any]) {
        debugPrint("Rewarded Get")
        delegate?.getRewardedCount()
    }
 
}

public protocol RewardADInstanceProtocol {
    func getRewardedCount()
}
#endif

