//
//  SecondView.swift
//  Example
//
//  Created by 狄烨 on 2023/9/5.
//

import SwiftUI
import AD_SwiftUI
struct SecondView: View {
    @State var shownAD = false
    var body: some View {
        
        ZStack{
            Text("Hello, World!")
            
            ADInterView(showAd: $shownAD, adUnitID: "FCD85F622AB5CC3DE3728973D1998B9B")
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
