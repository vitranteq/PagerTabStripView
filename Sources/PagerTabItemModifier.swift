//
//  PagerTabItemModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerTabItemModifier<NavTabView: View>: ViewModifier {

    private var navTabView: () -> NavTabView
    private var forceUpdate: Bool

    init(forceUpdate: Bool, navTabView: @escaping () -> NavTabView) {
        self.navTabView = navTabView
        self.forceUpdate = forceUpdate
    }

    func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onAppear {
                    DispatchQueue.main.async {
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        let newIndex = Int(round(frame.minX / self.settings.width))
                        guard frame != .zero else { return }
                        if dataStore.items[newIndex]?.view != nil {
                            let lastItem = dataStore.items[dataStore.itemsCount - 1]

                            if newIndex+1 < dataStore.itemsCount {
                                for i in (newIndex+1..<dataStore.itemsCount).reversed() {
                                    dataStore.items[i] = dataStore.items[i-1]
                                }
                            }
                            dataStore.remove(at: newIndex)
                            index = newIndex
                            setData(at: newIndex)
                            dataStore.items[dataStore.itemsCount] = lastItem

                            dataStore.forcepdateIndex.toggle()
                        } else {
                            index = newIndex
                            setData(at: index)
                        }
                    }
                }
                .onDisappear {
                    DispatchQueue.main.async {
                        dataStore.items[index]?.tabViewDelegate?.setState(state: .normal)
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        let newIndex = Int(round(frame.minX / self.settings.width))
                        if frame.minY < 0, index < dataStore.itemsCount - 1 { // khi frame sai thì đang remove một item
                            for i in index..<dataStore.itemsCount - 1 {
                                dataStore.items[i] = dataStore.items[i + 1]
                            }
                            dataStore.remove(at: dataStore.itemsCount - 1)
                            dataStore.forcepdateIndex.toggle()
                        } else {
                            dataStore.remove(at: index)
                        }
                    }
                }
                .onChange(of: dataStore.forcepdateIndex) { newValue in
                    let frame = reader.frame(in: .named("PagerViewScrollView"))
                    let newIndex = Int(round(frame.minX / self.settings.width))
                    index = newIndex
                }
                .onChange(of: forceUpdate) { _ in
                    dataStore.forcepdateIndex.toggle()
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @State private var index = -1

    func setData(at index: Int) {
        let tabView = navTabView()
        let tabViewDelegate = tabView as? PagerTabViewDelegate
        dataStore.setView(AnyView(tabView), at: index)
        dataStore.setTabViewDelegate(tabViewDelegate, at: index)
    }
}
