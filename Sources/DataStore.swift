//
//  DataStore.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

class DataItem {
    var view: AnyView?
    var tabViewDelegate: PagerTabViewDelegate?
    var appearCallback: (() -> Void)?
    var firstAppearCallback: (() -> Void)?
    @Published var itemWidth: Double?

    init(view: AnyView? = nil, tabViewDelegate: PagerTabViewDelegate? = nil, callback: (() -> Void)? = nil, firstAppearCallBack: (() -> Void)? = nil) {
        self.view = view
        self.appearCallback = callback
        self.tabViewDelegate = tabViewDelegate
        self.firstAppearCallback = firstAppearCallBack
    }
}

class DataStore: ObservableObject {
    @Published var items = [Int: DataItem]() {
        didSet {
            itemsCount = items.count
        }
    }

    @Published private(set) var itemsCount: Int = 0
    @Published var widthUpdated: Bool = false
    @Published var forceUpdate: Bool = false

    func setView(_ view: AnyView, at index: Int) {
        if let item = items[index] {
            item.view = view
        } else {
            items[index] = DataItem(view: view)
        }
    }

    func setTabViewDelegate(_ tabViewDelegate: PagerTabViewDelegate?, at index: Int) {
        if let item = items[index] {
            item.tabViewDelegate = tabViewDelegate
        } else {
            items[index] = DataItem(tabViewDelegate: tabViewDelegate)
        }
    }

    func setAppear(callback: @escaping () -> Void, at index: Int) {
        if let item = items[index] {
            item.appearCallback = callback
        } else {
            items[index] = DataItem(view: nil, callback: callback)
        }
    }

    func setFirstAppear(callback: @escaping () -> Void, at index: Int) {
        if let item = items[index] {
            item.firstAppearCallback = callback
        } else {
            items[index] = DataItem(view: nil, firstAppearCallBack: callback)
        }
    }

    func remove(at index: Int) {
        items[index] = nil
    }
}
