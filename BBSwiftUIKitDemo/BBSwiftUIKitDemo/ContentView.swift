//
//  ContentView.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 4/19/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI

struct MenuItem<Content: View> {
    let title: String
    let view: Content
}

extension View {
    var toAnyView: AnyView { AnyView(self) }
}

struct ContentView: View {
    let items: [MenuItem<AnyView>] = [
        MenuItem(title: "Scroll view", view: ScrollViewExample().toAnyView),
        MenuItem(title: "Scroll view 2", view: ScrollViewExample2().toAnyView),
        MenuItem(title: "Scroll view 3", view: ScrollViewExample3().toAnyView),
        MenuItem(title: "Scroll view 4", view: ScrollViewExample4().toAnyView),
        MenuItem(title: "Page control", view: PageControlExample().toAnyView),
        MenuItem(title: "Cycle view manual", view: CycleViewExample(autoDisplay: false).toAnyView),
        MenuItem(title: "Cycle view auto", view: CycleViewExample(autoDisplay: true).toAnyView),
        MenuItem(title: "Table view", view: TableViewExample().toAnyView)
    ]
    
    var body: some View {
        NavigationView {
            List(items, id: \.title) { item in
                NavigationLink(destination: item.view) {
                    Text(item.title)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
