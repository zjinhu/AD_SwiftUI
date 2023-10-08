//
//  SecondView.swift
//  Example
//
//  Created by 狄烨 on 2023/9/5.
//

import SwiftUI
import AD_SwiftUI
struct SecondView: View {

    var body: some View {
        
        ZStack{
            Text("Hello, World!")
        }
        .adInter(adUnitID: "C2473827BF2C0AE6355B428078F7F93E")
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
