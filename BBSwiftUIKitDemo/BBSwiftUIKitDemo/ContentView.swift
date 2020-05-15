//
//  ContentView.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 4/19/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ScrollViewExample()) {
                    Text("Scroll view")
                }
                NavigationLink(destination: ScrollViewExample2()) {
                    Text("Scroll view 2")
                }
                NavigationLink(destination: ScrollViewExample3()) {
                    Text("Scroll view 3")
                }
                NavigationLink(destination: ScrollViewExample4()) {
                    Text("Scroll view 4")
                }
                NavigationLink(destination: PageControlExample()) {
                    Text("Page control")
                }
                NavigationLink(destination: CycleViewExample(autoDisplay: false)) {
                    Text("Cycle view manual")
                }
                NavigationLink(destination: CycleViewExample(autoDisplay: true)) {
                    Text("Cycle view auto")
                }
                NavigationLink(destination: TableViewExample()) {
                    Text("Table view")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
