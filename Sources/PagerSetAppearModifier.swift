//
//  PagerSetAppearModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerSetAppearItemModifier: ViewModifier {

    private var onPageAppear: () -> Void

    init(onPageAppear: @escaping () -> Void) {
        self.onPageAppear = onPageAppear
    }

    func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onChange(of: dataStore.forcepdateIndex, perform: { newValue in
                    DispatchQueue.main.async {
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        let newIndex = Int(round(frame.minX / self.settings.width))
                        if newIndex >= 0, newIndex < dataStore.itemsCount {
                            index = newIndex
                            dataStore.setAppear(callback: onPageAppear, at: index)
                        }
                    }
                })
                .onAppear {
                    DispatchQueue.main.async {
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        let newIndex = Int(round(frame.minX / self.settings.width))
                        if dataStore.items[index] == nil {
                            index = newIndex
                            dataStore.setAppear(callback: onPageAppear, at: index)
                        }
                    }
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @Environment(\.pagerStyle) var style: PagerStyle
    @State private var index = -1
}
