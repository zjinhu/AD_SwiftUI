//
//  BannerAdView.swift
//  Eraser
//
//  Created by 狄烨 on 2023/8/5.
//
import SwiftUI
import UIKit
#if canImport(TradPlusAds)
import TradPlusAds

public struct ADBannerView: UIViewControllerRepresentable {
    
    @State private var viewSize: CGSize = .zero
    
    private let bannerView = TradPlusAdBanner()
     
    @Environment(\.adUnitID) private var adUnitID
    
    public init() { }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let bannerViewController = BannerViewController()
        if let adUnitID{
            bannerView.delegate = context.coordinator
            bannerView.setAdUnitID(adUnitID)
//            bannerView.autoShow = true
            bannerView.frame = bannerViewController.view.bounds
            bannerViewController.view.addSubview(bannerView)
            bannerViewController.delegate = context.coordinator
        }
        return bannerViewController
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        debugPrint("size: \(viewSize)")
        guard viewSize != .zero else { return }
        bannerView.setBannerSize(viewSize)
        bannerView.loadAd(withSceneId: nil)
    }

    public class Coordinator: NSObject,TradPlusADBannerDelegate,BannerViewControllerWidthDelegate {
        
        let parent: ADBannerView
        
        init(_ parent: ADBannerView) {
            self.parent = parent
        }
        
        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate size: CGSize) {
            parent.viewSize = size
        }
        
//        public func showAD(){
//            if parent.bannerView.isAdReady == true{
//                parent.bannerView.show(withSceneId: nil)
//            }
//        }
        
        public func tpBannerAdLoaded(_ adInfo: [AnyHashable : Any]) {
            debugPrint("Banner AdLoaded")
//            showAD()
        }
        
        public func tpBannerAdLoadFailWithError(_ error: Error) {
            debugPrint("Banner AdLoadFail")
        }
        
        public func tpBannerAdImpression(_ adInfo: [AnyHashable : Any]) {
            debugPrint("Banner AdImpression")
        }
        
        public func tpBannerAdShow(_ adInfo: [AnyHashable : Any], didFailWithError error: Error) {
            debugPrint("Banner AdDidShow:Error\(error)")
        }
        
        public func tpBannerAdClicked(_ adInfo: [AnyHashable : Any]) {
            debugPrint("Banner AdClicked")
        }
    }
}

protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate size: CGSize)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate?.bannerViewController(
            self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in } completion: { _ in
            // Notify the delegate of ad width changes.
            self.delegate?.bannerViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size)
        }
    }
}
#endif
