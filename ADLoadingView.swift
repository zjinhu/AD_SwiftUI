//
//  ADLoadingView.swift
//  AD_SwiftUI
//
//  Created by 狄烨 on 2023/10/8.
//

import SwiftUI
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
