//
//  ScrollViewExample4.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 4/19/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct ScrollViewExample4: View {
    @State var contentOffset: CGPoint = .zero
    
    var body: some View {
        BBScrollView([.horizontal, .vertical]) {
            Text("Hello, World!")
            Image(systemName: "heart")
        }
    }
}

struct ScrollViewExample4_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewExample4()
    }
}
