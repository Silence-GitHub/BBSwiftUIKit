//
//  CycleView.swift
//  BBSwiftUIKitDemo
//
//  Created by Kaibo Lu on 5/4/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct CycleView: View {
    @ObservedObject private var model: CycleViewModel
    
    init(names: [String], pageSize: CGSize, autoDisplay: Bool) {
        model = CycleViewModel(names: names, pageSize: pageSize, autoDisplay: autoDisplay)
    }
    
    var body: some View {
        VStack {
            BBScrollView(.horizontal, contentOffset: $model.contentOffset) {
                HStack(spacing: 0) {
                    ForEach(self.model.nameIndexes, id: \.self) { i in
                        Image(systemName: self.model.names[i])
                            .resizable()
                            .scaledToFit()
                            .frame(width: self.model.pageSize.width, height: self.model.pageSize.height)
                    }
                }
            }
            .bb_showsHorizontalScrollIndicator(false)
            .bb_isPagingEnabled(true)
            .bb_contentOffsetToScrollAnimated($model.contentOffsetToScrollAnimated)
            .onAppear {
                self.model.appear = true
                self.model.start()
            }
            .onDisappear {
                self.model.appear = false
                self.model.stop()
            }
            
            BBPageControl(currentPage: $model.index, numberOfPages: model.names.count)
                .background(Color.black)
        }
    }
}

struct CycleView_Previews: PreviewProvider {
    static var previews: some View {
        CycleView(names: ["sun.max", "moon", "star", "cloud"], pageSize: CGSize(width: UIScreen.main.bounds.width, height: 500), autoDisplay: false)
    }
}

fileprivate class CycleViewModel: ObservableObject {
    let names: [String]
    let pageSize: CGSize
    let autoDisplay: Bool
    
    var appear: Bool = false
    var timer: Timer?
    
    @Published var index = 0
    
    @Published var contentOffset: CGPoint {
        didSet {
            if contentOffset.x <= 0 {
                index = nameIndexes[0]
                contentOffset.x += pageSize.width
            } else if contentOffset.x >= pageSize.width * 2 {
                index = nameIndexes[2]
                contentOffset.x -= pageSize.width
            }
        }
    }
    
    @Published var contentOffsetToScrollAnimated: CGPoint? = nil
    
    var nameIndexes: [Int] {
        if index == 0 { return [names.count - 1, 0, 1] }
        let nextIndex = index == names.count - 1 ? 0 : index + 1
        return [index - 1, index, nextIndex]
    }
    
    init(names: [String], pageSize: CGSize, autoDisplay: Bool) {
        self.names = names
        self.pageSize = pageSize
        self.autoDisplay = autoDisplay
        self.contentOffset = CGPoint(x: pageSize.width, y: 0)
    }
    
    func start() {
        if !autoDisplay || timer != nil { return }
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            guard let self = self, self.appear else { return }
            self.contentOffsetToScrollAnimated = CGPoint(x: self.pageSize.width * 2, y: 0)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
