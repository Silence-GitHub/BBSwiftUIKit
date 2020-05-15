//
//  ScrollViewExample3.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 4/19/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct ScrollViewExample3: View {
    @State var contentOffset: CGPoint = .zero
    
    var body: some View {
        BBScrollView([.horizontal, .vertical], contentOffset: $contentOffset) {
            VStack {
                Text("1")
                    .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
                    .background(Color.red)
                Text("2")
                    .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
                    .background(Color.blue)
                Text("3")
                    .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
                    .background(Color.green)
            }
        }
    }
}

struct ScrollViewExample3_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewExample3()
    }
}
