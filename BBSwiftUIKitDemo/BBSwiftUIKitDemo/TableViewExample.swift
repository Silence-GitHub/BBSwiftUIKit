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

    class Model: ObservableObject {
        @Published var list: Range<Int> = 0..<100
        @Published var updateHeight: Bool = false
        @Published var reloadData: Bool = false
        @Published var reloadRows: [Int] = []
        @Published var scrollToRow: Int? = nil
        @Published var contentOffset: CGPoint = .zero
        @Published var contentOffsetToScrollAnimated: CGPoint? = nil
        @Published var isRefreshing: Bool = false
        @Published var isLoadingMore: Bool = false
        
        func reloadListData() {
            self.list = 0..<100
            self.updateHeight.toggle()
            self.reloadData = true
        }
        
        func reloadListRows() {
            list = 0..<100
            updateHeight.toggle()
            reloadRows = (0..<10).map { $0 }
        }
    }
    
    @ObservedObject var model = Model()
    
    var body: some View {
        VStack {
            BBTableView(model.list) { i in
                if i % 2 == 0 {
                    Text("\(i)\(self.model.updateHeight ? "" : "A")")
                        .frame(height: self.model.updateHeight ? 50 : 100)
                        .padding()
                        .background(Color.blue)
                } else {
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(height: self.model.updateHeight ? 20 : 40)
                        .padding()
                        .background(Color.orange)
                }
            }
            .bb_reloadData($model.reloadData)
            .bb_reloadRows($model.reloadRows, animation: .automatic)
            .bb_scrollToRow($model.scrollToRow, position: .none, animated: true)
            .bb_contentOffset($model.contentOffset)
            .bb_contentOffsetToScrollAnimated($model.contentOffsetToScrollAnimated)
            .bb_setupRefreshControl { refreshControl in
                refreshControl.tintColor = .blue
                refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
            }
            .bb_pullDownToRefresh(isRefreshing: $model.isRefreshing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.model.reloadListData()
                    self.model.isRefreshing = false
                }
            }
            .bb_pullUpToLoadMore(bottomSpace: 30) {
                if self.model.isLoadingMore { return }
                self.model.isLoadingMore = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.model.list = 0..<self.model.list.last! + 11
                    self.model.isLoadingMore = false
                }
            }
            
            Slider(value: $model.contentOffset.y, in: 0...1000)
            
            Button("Scroll to y = 1000") {
                self.model.contentOffsetToScrollAnimated = CGPoint(x: 0, y: 1000)
            }
            .padding()
            
            Button("Reload data") {
                self.model.reloadListData()
                self.model.scrollToRow = 0
            }
            .padding()
            
            Button("Reload rows") {
                self.model.reloadListRows()
                self.model.scrollToRow = 0
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
