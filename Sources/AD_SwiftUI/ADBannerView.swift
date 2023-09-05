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
    
    @State private var viewWidth: CGFloat = .zero
 
    private let bannerView = TradPlusAdBanner()
 
    private let adUnitID: String
    
    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let bannerViewController = BannerViewController()
 
        bannerView.setAdUnitID(adUnitID)
        bannerView.delegate = context.coordinator
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.delegate = context.coordinator
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: bannerViewController.view.topAnchor),
            bannerView.leftAnchor.constraint(equalTo: bannerViewController.view.leftAnchor),
            bannerView.bottomAnchor.constraint(equalTo: bannerViewController.view.bottomAnchor),
            bannerView.rightAnchor.constraint(equalTo: bannerViewController.view.rightAnchor),
        ])
 
        return bannerViewController
    }
 
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
 
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        debugPrint("size: \(viewWidth)")
        guard viewWidth != .zero else { return }
//        bannerView.frame = CGRect(x: 0, y: 0, width: Screen.realWidth, height: 50)
        bannerView.loadAd(withSceneId: nil)
 
    }
 
    public class Coordinator: NSObject,TradPlusADBannerDelegate,BannerViewControllerWidthDelegate {

        let parent: ADBannerView
        
        init(_ parent: ADBannerView) {
            self.parent = parent
        }
 
        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
            parent.viewWidth = width
        }
        
        public func tpBannerAdLoaded(_ adInfo: [AnyHashable : Any]) {
            debugPrint("Banner AdLoaded")
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
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        delegate?.bannerViewController(
            self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in } completion: { _ in
            // Notify the delegate of ad width changes.
            self.delegate?.bannerViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
        }
    }
}
#endif
