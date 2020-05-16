//
//  TableViewExample.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 5/14/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct TableViewExample: View {
    @State var list = 0..<100
    @State var updateHeight = false
    @State var reloadData = false
    @State var reloadRows: [Int] = []
    @State var contentOffset: CGPoint = .zero
    @State var contentOffsetToScrollAnimated: CGPoint? = nil
    
    var body: some View {
        VStack {
            BBTableView(list) { i in
                if i % 2 == 0 {
                    Text("\(i)")
                        .frame(height: self.updateHeight ? 50 : 100)
                        .padding()
                        .background(Color.blue)
                } else {
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(height: self.updateHeight ? 20 : 40)
                        .padding()
                        .background(Color.orange)
                }
            }
            .bb_reloadData($reloadData)
            .bb_reloadRows($reloadRows)
            .bb_contentOffsetToScrollAnimated($contentOffsetToScrollAnimated)
            .bb_contentOffset($contentOffset)
            
            Slider(value: $contentOffset.y, in: 0...1000)
            
            Button("Scroll to y = 1000") {
                self.contentOffsetToScrollAnimated = CGPoint(x: 0, y: 1000)
            }
            .padding()
            
            Button("Reload data") {
                if self.list.count > 50 {
                    self.list = 0..<50
                } else {
                    self.list = 0..<100
                }
                self.updateHeight.toggle()
                
                self.reloadData = true
            }
            .padding()
            
            Button("Reload rows") {
                if self.list.count > 50 {
                    self.list = 0..<50
                } else {
                    self.list = 0..<100
                }
                self.updateHeight.toggle()
                
                self.reloadRows = (0..<10).map { $0 }
            }
            .padding()
        }
    }
}

struct TableViewExample_Previews: PreviewProvider {
    static var previews: some View {
        TableViewExample()
    }
}
