//
//  PagerTabStripReorderable.swift
//  PagerTabStripView
//
//  Created by Phat Le on 06/10/2022.
//

import Foundation

public protocol PagerTabStripReorderable: AnyObject {
    associatedtype TabItem: Hashable

    var originalTabs: [TabItem] { get set }
    var tabs: [TabItem] { get set }
    var isReordered: Bool { get set }
    var itemCountChange: Bool { get set }
    var selection: Int { get set }
    var hiddenTabs: [TabItem] { get set }
}

public extension PagerTabStripReorderable {
    func updateTabs(countChanged: Bool = false) {
        //
        let currentTab = tabs[selection]

        //
        let newTabs = originalTabs.filter { !self.hiddenTabs.contains($0) }
        guard newTabs != tabs else { return }
        tabs = newTabs

        //
        if let newSelection = tabs.firstIndex(of: currentTab),
           newSelection != selection {
            selection = newSelection
        }

        //
        if countChanged {
            itemCountChange.toggle()
            isReordered.toggle()
        } else {
            // for re-order only
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.isReordered.toggle()
            }
        }
    }

    func change(tab: TabItem, isOn: Bool) {
        switch isOn {
        case true:
            hiddenTabs.removeAll { $0 == tab }
        case false:
            hiddenTabs.append(tab)
        }

        //
        updateTabs(countChanged: true)
    }
}
