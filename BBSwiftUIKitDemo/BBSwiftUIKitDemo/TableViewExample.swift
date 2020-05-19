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
    @State var scrollToRow: BBTableViewScrollToRowParameter? = nil
    @State var contentOffset: CGPoint = .zero
    @State var contentOffsetToScrollAnimated: CGPoint? = nil
    @State var isRefreshing: Bool = false
    
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
            .bb_scrollToRow($scrollToRow)
            .bb_contentOffset($contentOffset)
            .bb_contentOffsetToScrollAnimated($contentOffsetToScrollAnimated)
            .bb_setupRefreshControl { refreshControl in
                refreshControl.tintColor = .blue
                refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
            }
            .bb_pullDownToRefresh($isRefreshing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.reloadListData()
                    self.isRefreshing = false
                }
            }
            
            Slider(value: $contentOffset.y, in: 0...1000)
            
            Button("Scroll to y = 1000") {
                self.contentOffsetToScrollAnimated = CGPoint(x: 0, y: 1000)
            }
            .padding()
            
            Button("Reload data") {
                self.reloadListData()
                self.scrollToRow = BBTableViewScrollToRowParameter(row: 0, position: .top, animated: true)
            }
            .padding()
            
            Button("Reload rows") {
                self.reloadListRows()
                self.scrollToRow = BBTableViewScrollToRowParameter(row: 0, position: .top, animated: true)
            }
            .padding()
        }
    }
    
    private func reloadListData() {
        if self.list.count > 50 {
            self.list = 0..<50
        } else {
            self.list = 0..<100
        }
        self.updateHeight.toggle()
        self.reloadData = true
    }
    
    private func reloadListRows() {
        if self.list.count > 50 {
            self.list = 0..<50
        } else {
            self.list = 0..<100
        }
        self.updateHeight.toggle()
        self.reloadRows = (0..<10).map { $0 }
    }
}

struct TableViewExample_Previews: PreviewProvider {
    static var previews: some View {
        TableViewExample()
    }
}
