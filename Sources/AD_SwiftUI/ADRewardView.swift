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
    
    private let adInstanse = ADRewardInstance.shared
    private let action: () -> ()
    public init(adUnitID: String, action: @escaping () -> ()) {
        self.action = action
        adInstanse.adInstance.setAdUnitID(adUnitID)
        adInstanse.delegate = self
    }

    public func body(content: Content) -> some View {
        content
            .onAppear{
                adInstanse.loadAd()
            }
            .onTapGesture {
                adInstanse.showAD()
            }
    }
}

public class ADRewardInstance: NSObject, TradPlusADRewardedDelegate {
    public var delegate: RewardADInstanceProtocol?
    public lazy var adInstance: TradPlusAdRewarded = {
        let adInstance = TradPlusAdRewarded()
        adInstance.delegate = self
        return adInstance
    }()
    public static let shared = ADRewardInstance()
    private override init() {}

    public func loadAd() {
        adInstance.loadAd()
    }
    
    public func loadAd() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            adInstance.loadAd()
        }
    }
    
    public func showAD(){
        if adInstance.isAdReady == true{
            adInstance.showAd(withSceneId: nil)
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

