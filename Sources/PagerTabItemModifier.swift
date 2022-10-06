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
                        guard frame != .zero else { return }
                        let newIndex = Int(round(frame.minX / self.settings.width))
                        print("+++ frame onAppear \(frame)")
                        if dataStore.items[newIndex]?.view != nil {
                            if newIndex+1 <= dataStore.itemsCount {
                                for i in (newIndex+1...dataStore.itemsCount).reversed() {
                                    dataStore.items[i] = dataStore.items[i-1]
                                }
                            }
                            dataStore.remove(at: newIndex)
                            index = newIndex
                            setData(at: newIndex)

                            dataStore.forceUpdateIndex.toggle()
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
                        print("+++ frame onDisappear \(frame)")
//                        let newIndex = Int(round(frame.minX / self.settings.width))
                        if frame == .zero, index < dataStore.itemsCount - 1 { // khi frame sai thì đang remove một item
                            let lastItem = dataStore.items[dataStore.itemsCount - 1]
                            dataStore.remove(at: dataStore.itemsCount - 1)
                            for i in index..<dataStore.itemsCount - 1 {
                                dataStore.items[i] = dataStore.items[i + 1]
                            }
//                            dataStore.remove(at: dataStore.itemsCount - 1)
                            dataStore.items[dataStore.itemsCount - 1] = lastItem
                            dataStore.forceUpdateIndex.toggle()
                        } else {
                            dataStore.remove(at: index)
                        }
                    }
                }
                .onChange(of: dataStore.forceUpdateIndex) { newValue in
                    let frame = reader.frame(in: .named("PagerViewScrollView"))
                    let newIndex = Int(round(frame.minX / self.settings.width))
                    index = newIndex
                }
                .onChange(of: forceUpdate) { _ in
                    let frame = reader.frame(in: .named("PagerViewScrollView"))
                    let newIndex = Int(round(frame.minX / self.settings.width))
                    if newIndex != index {
                        let oldData = dataStore.items[index]
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            dataStore.items[newIndex] = oldData
                        }
                        index = newIndex
                    }
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
