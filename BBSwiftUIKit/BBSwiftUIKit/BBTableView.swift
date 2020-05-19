//
//  BBTableView.swift
//  BBSwiftUIKit
//
//  Created by Kaibo Lu on 5/14/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI

public extension CGFloat {
    static let bb_invalidBottomSpaceForLoadingMore = CGFloat.greatestFiniteMagnitude
}

public extension BBTableView {
    func bb_reloadData(_ reloadData: Binding<Bool>) -> Self {
        var view = self
        view._reloadData = reloadData
        return view
    }
    
    func bb_reloadRows(_ reloadRows: Binding<[Int]>) -> Self {
        var view = self
        view._reloadRows = reloadRows
        return view
    }
    
    func bb_scrollToRow(_ scrollToRow: Binding<BBTableViewScrollToRowParameter?>) -> Self {
        var view = self
        view._scrollToRow = scrollToRow
        return view
    }
    
    func bb_contentOffset(_ contentOffset: Binding<CGPoint>) -> Self {
        var view = self
        view._contentOffset = contentOffset
        return view
    }
    
    func bb_contentOffsetToScrollAnimated(_ contentOffsetToScrollAnimated: Binding<CGPoint?>) -> Self {
        var view = self
        view._contentOffsetToScrollAnimated = contentOffsetToScrollAnimated
        return view
    }
    
    func bb_setupRefreshControl(_ setupRefreshControl: @escaping (UIRefreshControl) -> Void) -> Self {
        var view = self
        view.setupRefreshControl = setupRefreshControl
        return view
    }
    
    func bb_pullDownToRefresh(isRefreshing: Binding<Bool>, refresh: @escaping () -> Void) -> Self {
        var view = self
        view._isRefreshing = isRefreshing
        view.pullDownToRefresh = refresh
        return view
    }
    
    func bb_pullUpToLoadMore(bottomSpace: CGFloat, loadMore: @escaping () -> Void) -> Self {
        var view = self
        view.bottomSpaceForLoadingMore = bottomSpace
        view.pullUpToLoadMore = loadMore
        return view
    }
}

public struct BBTableViewScrollToRowParameter {
    public let row: Int
    public let position: UITableView.ScrollPosition
    public let animated: Bool
    
    public init(row: Int, position: UITableView.ScrollPosition, animated: Bool) {
        self.row = row
        self.position = position
        self.animated = animated
    }
}

public struct BBTableView<Data, Content>: UIViewControllerRepresentable, BBUIScrollViewRepresentable where Data : RandomAccessCollection, Content : View, Data.Element : Equatable {
    let data: Data
    let content: (Data.Element) -> Content
    
    @Binding public var reloadData: Bool
    @Binding public var reloadRows: [Int]
    @Binding public var scrollToRow: BBTableViewScrollToRowParameter?
    @Binding public var contentOffset: CGPoint
    @Binding public var contentOffsetToScrollAnimated: CGPoint?
    public var isPagingEnabled: Bool
    public var bounces: Bool
    public var alwaysBounceVertical: Bool
    public var alwaysBounceHorizontal: Bool
    public var showsVerticalScrollIndicator: Bool
    public var showsHorizontalScrollIndicator: Bool
    
    @Binding public var isRefreshing: Bool
    public var setupRefreshControl: ((UIRefreshControl) -> Void)?
    public var pullDownToRefresh: (() -> Void)?
    public var bottomSpaceForLoadingMore: CGFloat
    public var pullUpToLoadMore: (() -> Void)?

    public init(_ data: Data,
                reloadData: Binding<Bool> = .constant(false),
                reloadRows: Binding<[Int]> = .constant([]),
                scrollToRow: Binding<BBTableViewScrollToRowParameter?> = .constant(nil),
                contentOffset: Binding<CGPoint> = .constant(.bb_invalidContentOffset),
                contentOffsetToScrollAnimated: Binding<CGPoint?> = .constant(nil),
                isPagingEnabled: Bool = false,
                bounces: Bool = true,
                alwaysBounceVertical: Bool = false,
                alwaysBounceHorizontal: Bool = false,
                showsVerticalScrollIndicator: Bool = true,
                showsHorizontalScrollIndicator: Bool = true,
                isRefreshing: Binding<Bool> = .constant(false),
                setupRefreshControl: ((UIRefreshControl) -> Void)? = nil,
                pullDownToRefresh: (() -> Void)? = nil,
                bottomSpaceForLoadingMore: CGFloat = .bb_invalidBottomSpaceForLoadingMore,
                pullUpToLoadMore: (() -> Void)? = nil,
                @ViewBuilder content: @escaping (Data.Element) -> Content)
    {
        self.data = data
        self.content = content
        self._reloadData = reloadData
        self._reloadRows = reloadRows
        self._scrollToRow = scrollToRow
        self._contentOffset = contentOffset
        self._contentOffsetToScrollAnimated = contentOffsetToScrollAnimated
        self.isPagingEnabled = isPagingEnabled
        self.bounces = bounces
        self.alwaysBounceVertical = alwaysBounceVertical
        self.alwaysBounceHorizontal = alwaysBounceHorizontal
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        self._isRefreshing = isRefreshing
        self.setupRefreshControl = setupRefreshControl
        self.pullDownToRefresh = pullDownToRefresh
        self.bottomSpaceForLoadingMore = bottomSpaceForLoadingMore
        self.pullUpToLoadMore = pullUpToLoadMore
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        _BBTableViewController(self)
    }

    public func updateUIViewController(_ viewController: UIViewController, context: Context) {
        let vc = viewController as! _BBTableViewController<Data, Content>
        updateScrollView(vc.tableView)
        vc.update(self)
    }
}

private class _BBTableViewController<Data, Content>: UIViewController, UITableViewDataSource, UITableViewDelegate where Data: RandomAccessCollection, Content: View, Data.Element: Equatable {
    var representable: BBTableView<Data, Content>
    var tableView: UITableView!
    
    var data: Data { representable.data }
    var content: (Data.Element) -> Content { representable.content }
    
    init(_ view: BBTableView<Data, Content>) {
        representable = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(_BBTableViewHostCell<Content>.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        if representable.setupRefreshControl != nil || representable.pullDownToRefresh != nil {
            let refreshControl = UIRefreshControl()
            representable.setupRefreshControl?(refreshControl)
            refreshControl.addTarget(self, action: #selector(pullDownToRefresh), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
        
        // TODO: Refresh when first will appear

        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: tableView.leftAnchor),
            view.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    func update(_ newRepresentable: BBTableView<Data, Content>) {
        if newRepresentable.reloadData {
            representable = newRepresentable
            tableView.reloadData()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.representable.reloadData = false
                self.representable.reloadRows.removeAll()
            }
        } else {
            var removals: [IndexPath] = []
            var insertions: [IndexPath] = []
            let diff = newRepresentable.data.difference(from: data)
            for step in diff {
                switch step {
                case let .remove(i, _, _): removals.append(IndexPath(row: i, section: 0))
                case let .insert(i, _, _): insertions.append(IndexPath(row: i, section: 0))
                }
            }
            
            representable = newRepresentable
            
            if !removals.isEmpty || !insertions.isEmpty {
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: removals, with: .automatic)
                    tableView.insertRows(at: insertions, with: .automatic)
                }, completion: nil)
            }
            
            if !representable.reloadRows.isEmpty {
                tableView.reloadRows(at: representable.reloadRows.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.representable.reloadRows.removeAll()
                }
            }
        }
        
        if let refreshControl = tableView.refreshControl,
            representable.isRefreshing != refreshControl.isRefreshing {
            if representable.isRefreshing {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
        
        if let scrollToRow = representable.scrollToRow {
            tableView.scrollToRow(at: IndexPath(row: scrollToRow.row, section: 0), at: scrollToRow.position, animated: scrollToRow.animated)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.representable.scrollToRow = nil
            }
        } else if let contentOffset = representable.contentOffsetToScrollAnimated {
            tableView.setContentOffset(contentOffset, animated: true)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.representable.contentOffsetToScrollAnimated = nil
            }
        } else if representable.contentOffset != .bb_invalidContentOffset {
            tableView.contentOffset = representable.contentOffset
        }
    }
    
    @objc private func pullDownToRefresh() {
        representable.isRefreshing = true
        representable.pullDownToRefresh?()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { data.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! _BBTableViewHostCell<Content>
        let index = data.index(data.startIndex, offsetBy: indexPath.row)
        let view = content(data[index])
        cell.update(view, parent: self)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.representable.contentOffset = scrollView.contentOffset
            
            if self.representable.bottomSpaceForLoadingMore != .bb_invalidBottomSpaceForLoadingMore,
                let loadMore = self.representable.pullUpToLoadMore {
                let space = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height
                if space <= self.representable.bottomSpaceForLoadingMore {
                    loadMore()
                }
            }
        }
    }
}

private class _BBTableViewHostCell<Content: View>: UITableViewCell {
    var host: UIHostingController<Content>!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ content: Content, parent: UIViewController) {
        if host == nil {
            host = UIHostingController(rootView: content)
            parent.addChild(host)

            host.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(host.view)

            NSLayoutConstraint.activate([
                contentView.leftAnchor.constraint(equalTo: host.view.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: host.view.rightAnchor),
                contentView.topAnchor.constraint(equalTo: host.view.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: host.view.bottomAnchor)
            ])

            host.didMove(toParent: parent)
        } else {
            host.rootView = content
        }
        host.view.setNeedsUpdateConstraints()
    }
}
