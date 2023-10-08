//
//  ContentView.swift
//  AD_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import AD_SwiftUI
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {

                Text("点击打开激励广告")
                    .adReward(adUnitID: "D620896F350D9081207BCFD2E74FB2E9") {
                        print("Reward + 1")
                    }
                
                NavigationLink {
                    SecondView()
                } label: {
                    Text("点击跳转插屏广告")
                }
                
                NavigationLink {
                    ThirdView()
                } label: {
                    Text("点击跳转loading广告")
                }

                
                ADBannerView()
                    .adUnitID("343487E550C2B2BBC2DF1D6540DC18F4")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .padding()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
