//
//  ScrollViewExample2.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 4/19/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct ScrollViewExample2: View {
    @State var contentOffset: CGPoint = .zero
    @State var showsVerticalScrollIndicator: Bool = true
    
    var body: some View {
        VStack {
            BBScrollView(.vertical, contentOffset: $contentOffset) {
                VStack {
                    Text("1")
                        .frame(width: 50, height: UIScreen.main.bounds.height)
                        .background(Color.red)
                    Text("2")
                        .frame(width: 50, height: UIScreen.main.bounds.height)
                        .background(Color.blue)
                    Text("3")
                        .frame(width: 50, height: UIScreen.main.bounds.height)
                        .background(Color.green)
                }
            }
            .bb_showsVerticalScrollIndicator(showsVerticalScrollIndicator)
            .edgesIgnoringSafeArea(.all)
            
            Slider(value: self.$contentOffset.y, in: 0...UIScreen.main.bounds.height * 2)
            
            Button("Shows vertical scroll indicator \(self.showsVerticalScrollIndicator ? "true" : "false")") {
                self.showsVerticalScrollIndicator.toggle()
            }
            .padding()
        }
    }
}

struct ScrollViewExample2_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewExample2()
    }
}
