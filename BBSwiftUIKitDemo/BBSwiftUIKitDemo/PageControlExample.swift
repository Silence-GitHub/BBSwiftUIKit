//
//  PageControlExample.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 5/12/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct PageControlExample: View {
    @State var currentPage: Int = 0
    @State var numberOfPages: Int = 5
    @State var hidesForSinglePage: Bool = false
    @State var pageIndicatorTintColor: UIColor?
    @State var currentPageIndicatorTintColor: UIColor?
    
    var body: some View {
        VStack {
            BBPageControl(currentPage: $currentPage, numberOfPages: numberOfPages)
                .bb_hidesForSinglePage(hidesForSinglePage)
                .bb_pageIndicatorTintColor(pageIndicatorTintColor)
                .bb_currentPageIndicatorTintColor(currentPageIndicatorTintColor)
                .background(Color.black)
            
            Button("Current page \(currentPage)") {
                self.currentPage = self.numberOfPages == 0 ? 0 : (self.currentPage + 1) % self.numberOfPages
            }
            .padding()
            
            Button("Number of pages \(numberOfPages)") {
                self.numberOfPages = (self.numberOfPages + 1) % 10
            }
            .padding()
            
            Button("Hides for single page \(hidesForSinglePage ? "true" : "false")") {
                self.hidesForSinglePage.toggle()
            }
            .padding()
            
            Button("Page indicator tint color \(pageIndicatorTintColor == nil ? "nil" : "blue")") {
                self.pageIndicatorTintColor = self.pageIndicatorTintColor == nil ? .blue : nil
            }
            .padding()
            
            Button("Current page indicator tint color \(currentPageIndicatorTintColor == nil ? "nil" : "red")") {
                self.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor == nil ? .red : nil
            }
            .padding()
        }
    }
}

struct PageControlExample_Previews: PreviewProvider {
    static var previews: some View {
        PageControlExample()
    }
}
