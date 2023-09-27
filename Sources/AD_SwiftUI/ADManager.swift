//
//  File.swift
//  
//
//  Created by 狄烨 on 2023/9/4.
//

import Foundation
import AdSupport
import AppTrackingTransparency
import SwiftUI
import UIKit
import os

extension View {
    @inlinable
    public func checkADTracking() -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            ADManager.checkTrackingAuthorization()
        }
    }
}

extension View {
    public func adUnitID(_ adUnitID: String) -> some View {
        environment(\.adUnitID, adUnitID)
    }
}

extension EnvironmentValues {
    var adUnitID: String? {
        get { self[AdUnitIDEnvironmentKey.self] }
        set { self[AdUnitIDEnvironmentKey.self] = newValue }
    }
}

struct AdUnitIDEnvironmentKey: EnvironmentKey {
    static var defaultValue: String?
}

public class ADManager{
    public static func checkTrackingAuthorization() {
        if !UserDefaults.standard.bool(forKey: "isPro.InPurchase"){
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                logger.log("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied:
                logger.log("IDFA denied")
            case .restricted:
                logger.log("IDFA restricted")
            case .notDetermined:
                showRequestTrackingAuthorizationAlert()
            @unknown default:
                fatalError()
            }
        }
    }
    
    private static func showRequestTrackingAuthorizationAlert() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            switch status {
            case .authorized:
                logger.log("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied, .restricted, .notDetermined:
                logger.log("IDFA been denied!!!")
            @unknown default:
                fatalError()
            }
        })
    }
}

#if canImport(TradPlusAds)
import TradPlusAds
extension ADManager{
    public static func initTradPlusAds(_ appId: String) {
        if !UserDefaults.standard.bool(forKey: "isPro.InPurchase"){
            TradPlus.setLogLevel(MSLogLevel.init(rawValue: 70))
            TradPlus.initSDK(appId) { error in
                if let error {
                    logger.log("SDK初始化Error:\(error)")
                }else{
                    logger.log("SDK初始化Success")
                }
            }
        }
    }
}
#endif

extension UIWindow {
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.windows.first { $0.isKeyWindow } }
            .first
    }
}

private extension UIScene.ActivationState {
    var sortPriority: Int {
        switch self {
        case .foregroundActive: return 1
        case .foregroundInactive: return 2
        case .background: return 3
        case .unattached: return 4
        @unknown default: return 5
        }
    }
}

struct OnFirstAppear: ViewModifier {
    let action: (() -> Void)?
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                action?()
            }
        }
    }
}
extension View {
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnFirstAppear(action: action))
    }
}

let logger = ADLog()

struct ADLog {
    private let logger: Logger
     
    init(subsystem: String = "ADLog", category: String = "ADLog") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
}
 
extension ADLog {
    func log(_ message: String){
        logger.log("📣\(message)")
    }
}
