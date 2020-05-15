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
            Button("Update") {
                if self.list.count > 50 {
                    self.list = 0..<50
                } else {
                    self.list = 0..<100
                }
                self.updateHeight.toggle()
            }
        }
    }
}

struct TableViewExample_Previews: PreviewProvider {
    static var previews: some View {
        TableViewExample()
    }
}
