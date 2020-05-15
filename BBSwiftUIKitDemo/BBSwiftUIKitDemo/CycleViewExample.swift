//
//  CycleViewExample.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 5/12/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct CycleViewExample: View {
    let autoDisplay: Bool
    
    @State var index: Int = 0
    
    private let names: [String] = ["sun.max", "moon", "star", "cloud"]
    
    var body: some View {
        CycleView(names: names, pageSize: CGSize(width: UIScreen.main.bounds.width, height: 500), autoDisplay: autoDisplay)
    }
}

struct CycleViewExample_Previews: PreviewProvider {
    static var previews: some View {
        CycleViewExample(autoDisplay: false)
    }
}
