//
//  DataStore.swift
//  PagerTabStrip
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import Combine
import SwiftUI

class DataItem {
    var view: AnyView?
    var tabViewDelegate: PagerTabViewDelegate?
    var appearCallback: (() -> Void)?
    var disappearCallback: (() -> Void)?

    init(view: AnyView?, tabViewDelegate: PagerTabViewDelegate? = nil, appearCallback: (() -> Void)? = nil, disappearCallback: (() -> Void)? = nil) {
        self.view = view
        self.appearCallback = appearCallback
        self.disappearCallback = disappearCallback
        self.tabViewDelegate = tabViewDelegate
    }
}

class DataStore: ObservableObject {
    @Published var items = [Int: DataItem](){
        didSet {
            itemsCount = items.count
        }
    }

    @Published private(set) var itemsCount: Int = 0


    func setView(_ view: AnyView, tabViewDelegate: PagerTabViewDelegate? = nil, at index: Int) {
        if let item = items[index] {
            item.view = view
            item.tabViewDelegate = tabViewDelegate
        } else {
            items[index] = DataItem(view: view, tabViewDelegate: tabViewDelegate)
        }
    }

    func setAppear(callback: @escaping () -> Void, at index: Int) {
        if let item = items[index] {
            item.appearCallback = callback
        } else {
            items[index] = DataItem(view: nil, appearCallback: callback)
        }
    }

    func setDisappear(callback: @escaping () -> Void, at index: Int) {
        if let item = items[index] {
            item.disappearCallback = callback
        } else {
            items[index] = DataItem(view: nil, disappearCallback: callback)
        }
    }

    func remove(at index: Int) {
        items[index] = nil
    }
}
