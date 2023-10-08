//
//  ADLoadingView.swift
//  AD_SwiftUI
//
//  Created by 狄烨 on 2023/10/8.
//

import SwiftUI
import Foundation
#if canImport(InPurchase)
import InPurchase
#endif
public struct ADLoadingView<Content>: View where Content: View {
#if canImport(InPurchase)
    @EnvironmentObject private var inPurchase: InPurchase
#endif
    @Environment(\.adUnitID) private var adUnitID
    
    @Binding var isShowing: Bool
    private var content: () -> Content
    
    public init(isShowing: Binding<Bool>, @ViewBuilder _ content: @escaping () -> Content) {
        self._isShowing = isShowing
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            self.content()
                .disabled(isShowing)
            
            BlurView()
                .ignoresSafeArea()
                .opacity(isShowing ? 1 : 0)
            
            ZStack{
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                
                ProgressView()
                    .frame(width: 50, height: 50)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
#if os(iOS)
                    .scaleEffect(2)
#endif
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)
            .opacity(isShowing ? 1 : 0)
            .shadow(color: .gray, radius: 5)
            
#if canImport(InPurchase)
            if !inPurchase.isPro{
                if let adUnitID{
                    VStack{
                        Spacer()
                        
                        ADBannerView()
                            .adUnitID(adUnitID)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .padding(.bottom, 30)
                    }
                    .opacity(isShowing ? 1 : 0)
                }
            }
#endif
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ADLoadingView(isShowing: .constant(true)) {
        NavigationView {
            List(["1", "2", "3", "4", "5"], id: \.self) { row in
                Text(row)
            }.navigationBarTitle(Text("Loader Test"), displayMode: .large)
        }
    }
}

#if os(macOS)
import AppKit
struct BlurView: NSViewRepresentable {
    typealias NSViewType = NSView

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        nsView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
    }
}
#else
import UIKit
struct BlurView: UIViewRepresentable {
    typealias UIViewType = GlassmorphismView
    func makeUIView(context: Context) -> GlassmorphismView {
        let glassmorphismView = GlassmorphismView()
        return glassmorphismView
    }
    
    func updateUIView(_ uiView: GlassmorphismView, context: Context) {
        uiView.setBlurDensity(with: 0.1)
    }
}

class GlassmorphismView: UIView {

    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var animatorCompletionValue: CGFloat = 0.2
    private let backgroundView = UIView()
    override var backgroundColor: UIColor? {
        get {
            return .clear
        }
        set {}
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    deinit {
        animator.pauseAnimation()
        animator.stopAnimation(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setBlurDensity(with density: CGFloat) {
        self.animatorCompletionValue = (1 - density)
        self.animator.fractionComplete = animatorCompletionValue
    }

    private func initialize() {

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: self.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        animator.addAnimations {
            self.blurView.effect = nil
        }
        animator.fractionComplete = animatorCompletionValue
    }
 
}
#endif
