//
//  ScrollViewExample.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 4/19/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct ScrollViewExample: View {
    @State var contentOffset: CGPoint = .zero
    @State var bounces: Bool = true
    @State var isPagingEnabled: Bool = false
    @State var showsHorizontalScrollIndicator: Bool = true
    @State var contentOffsetToScrollAnimated: CGPoint? = nil
    @State var longContent: Bool = false
    
    var body: some View {
        VStack {
            BBScrollView(.horizontal, contentOffset: $contentOffset) {
                HStack(spacing: 0) {
                    Text(self.longContent ? "AAA" : "A")
                        .frame(width: UIScreen.main.bounds.width)
                        .background(Color.red)
                    Text(self.longContent ? "BBB" : "B")
                        .frame(width: UIScreen.main.bounds.width)
                        .background(Color.blue)
                    if self.longContent {
                        Text("CCC")
                            .frame(width: UIScreen.main.bounds.width)
                            .background(Color.green)
                    }
                }
            }
            .bb_bounces(bounces)
            .bb_isPagingEnabled(isPagingEnabled)
            .bb_showsHorizontalScrollIndicator(showsHorizontalScrollIndicator)
            .bb_contentOffsetToScrollAnimated($contentOffsetToScrollAnimated)
            
            Slider(value: $contentOffset.x, in: 0...UIScreen.main.bounds.width * (self.longContent ? 2 : 1))
            
            Button("Scroll to x = 100") {
                self.contentOffsetToScrollAnimated = CGPoint(x: 100, y: 0)
            }
            .padding()
            
            Button("Bounces \(bounces ? "true" : "false")") {
                self.bounces.toggle()
            }
            .padding()
            
            Button("Paging enabled \(isPagingEnabled ? "true" : "false")") {
                self.isPagingEnabled.toggle()
            }
            .padding()
            
            Button("Shows horizontal scroll indicator \(showsHorizontalScrollIndicator ? "true" : "false")") {
                self.showsHorizontalScrollIndicator.toggle()
            }
            .padding()
            
            Button("\(longContent ? 3 : 2) screen width") {
                self.longContent.toggle()
            }
            .padding()
        }
    }
}

struct ScrollViewExample_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewExample()
    }
}
