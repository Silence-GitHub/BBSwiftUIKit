//
//  BBScrollView.swift
//  BBSwiftUIKit
//
//  Created by Kaibo Lu on 4/19/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI

public extension CGPoint {
    static let bb_invalidContentOffset = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
}

public extension BBScrollView {
    func bb_contentOffset(_ contentOffset: Binding<CGPoint>) -> BBScrollView {
        var view = self
        view._contentOffset = contentOffset
        return view
    }
    
    func bb_contentOffsetToScrollAnimated(_ contentOffsetToScrollAnimated: Binding<CGPoint?>) -> BBScrollView {
        var view = self
        view._contentOffsetToScrollAnimated = contentOffsetToScrollAnimated
        return view
    }
    
    func bb_isPagingEnabled(_ isPagingEnabled: Bool) -> BBScrollView {
        var view = self
        view.isPagingEnabled = isPagingEnabled
        return view
    }
    
    func bb_bounces(_ bounces: Bool) -> BBScrollView {
        var view = self
        view.bounces = bounces
        return view
    }
    
    func bb_alwaysBounceVertical(_ alwaysBounceVertical: Bool) -> BBScrollView {
        var view = self
        view.alwaysBounceVertical = alwaysBounceVertical
        return view
    }
    
    func bb_alwaysBounceHorizontal(_ alwaysBounceHorizontal: Bool) -> BBScrollView {
        var view = self
        view.alwaysBounceHorizontal = alwaysBounceHorizontal
        return view
    }
    
    func bb_showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> BBScrollView {
        var view = self
        view.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return view
    }
    
    func bb_showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> BBScrollView {
        var view = self
        view.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        return view
    }
}

public struct BBScrollView<Content: View>: UIViewRepresentable {
    let axis: Axis.Set
    @Binding var contentOffset: CGPoint
    @Binding var contentOffsetToScrollAnimated: CGPoint?
    var isPagingEnabled: Bool
    var bounces: Bool
    var alwaysBounceVertical: Bool
    var alwaysBounceHorizontal: Bool
    var showsVerticalScrollIndicator: Bool
    var showsHorizontalScrollIndicator: Bool
    let content: () -> Content
    
    public init(_ axis: Axis.Set,
                contentOffset: Binding<CGPoint> = .constant(.bb_invalidContentOffset),
                contentOffsetToScrollAnimated: Binding<CGPoint?> = .constant(nil),
                isPagingEnabled: Bool = false,
                bounces: Bool = true,
                alwaysBounceVertical: Bool = false,
                alwaysBounceHorizontal: Bool = false,
                showsVerticalScrollIndicator: Bool = true,
                showsHorizontalScrollIndicator: Bool = true,
                @ViewBuilder content: @escaping () -> Content)
    {
        self.axis = axis
        self._contentOffset = contentOffset
        self._contentOffsetToScrollAnimated = contentOffsetToScrollAnimated
        self.isPagingEnabled = isPagingEnabled
        self.bounces = bounces
        self.alwaysBounceVertical = alwaysBounceVertical
        self.alwaysBounceHorizontal = alwaysBounceHorizontal
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        self.content = content
    }
    
    public func makeUIView(context: Context) -> UIScrollView {
        let scrollView = _BBScrollView(axis)
        scrollView.delegate = context.coordinator
        
        let host = UIHostingController(rootView: content())
        host.view.translatesAutoresizingMaskIntoConstraints = false
        context.coordinator.host = host
        
        scrollView.addSubview(host.view)
        
        if axis.contains(.horizontal) && axis.contains(.vertical) {
            NSLayoutConstraint.activate([
                scrollView.leftAnchor.constraint(equalTo: host.view.leftAnchor),
                scrollView.rightAnchor.constraint(equalTo: host.view.rightAnchor),
                scrollView.topAnchor.constraint(equalTo: host.view.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: host.view.bottomAnchor),
            ])
        } else if axis.contains(.horizontal) {
            NSLayoutConstraint.activate([ scrollView.centerYAnchor.constraint(equalTo: host.view.centerYAnchor) ])
            scrollView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        } else if axis.contains(.vertical) {
            NSLayoutConstraint.activate([ scrollView.centerXAnchor.constraint(equalTo: host.view.centerXAnchor) ])
            scrollView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        } else {
            assertionFailure("No axis for BBScrollView")
        }
        return scrollView
    }
    
    public func updateUIView(_ scrollView: UIScrollView, context: Context) {
        if let contentOffset = contentOffsetToScrollAnimated {
            scrollView.setContentOffset(contentOffset, animated: true)
            DispatchQueue.main.async {
                self.contentOffsetToScrollAnimated = nil
            }
        } else if contentOffset != .bb_invalidContentOffset {
            scrollView.contentOffset = contentOffset
        }
        scrollView.isPagingEnabled = isPagingEnabled
        scrollView.bounces = bounces
        scrollView.alwaysBounceVertical = alwaysBounceVertical
        scrollView.alwaysBounceHorizontal = alwaysBounceHorizontal
        scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        
        let host = context.coordinator.host!
        host.rootView = content()
        host.view.setNeedsUpdateConstraints()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = host.view.frame.size
    }
    
    public func makeCoordinator() -> BBScrollView<Content>.Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: BBScrollView
        var host: UIHostingController<Content>!
        
        init(_ view: BBScrollView) { parent = view }
        
        // MARK: UIScrollViewDelegate
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.contentOffset = scrollView.contentOffset
            }
        }
    }
}

private class _BBScrollView: UIScrollView {
    let axis: Axis.Set
    
    init(_ axis: Axis.Set) {
        self.axis = axis
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        if axis.contains(.horizontal) && !axis.contains(.vertical) {
            return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        }
        if axis.contains(.vertical) && !axis.contains(.horizontal) {
            return CGSize(width: contentSize.width, height: UIView.noIntrinsicMetric)
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}
