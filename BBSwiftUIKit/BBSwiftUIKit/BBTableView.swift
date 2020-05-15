//
//  BBTableView.swift
//  BBSwiftUIKit
//
//  Created by Kaibo Lu on 5/14/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//

import SwiftUI

public struct BBTableView<Data, Content>: UIViewControllerRepresentable where Data : RandomAccessCollection, Content : View, Data.Element : Equatable {
    let data: Data
    let content: (Data.Element) -> Content

    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        _BBTableViewController(self)
    }

    public func updateUIViewController(_ vc: UIViewController, context: Context) {
        (vc as! _BBTableViewController).update(self)
    }
}

private class _BBTableViewController<Data, Content>: UIViewController, UITableViewDataSource where Data: RandomAccessCollection, Content: View, Data.Element: Equatable {
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
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: tableView.leftAnchor),
            view.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    func update(_ newRepresentable: BBTableView<Data, Content>) {
        if tableView.window == nil { return }
        
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
        
        tableView.beginUpdates()
        if !removals.isEmpty { tableView.deleteRows(at: removals, with: .automatic) }
        if !insertions.isEmpty { tableView.insertRows(at: insertions, with: .automatic) }
        tableView.endUpdates()
        
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows { tableView.reloadRows(at: visibleIndexPaths, with: .automatic) }
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
