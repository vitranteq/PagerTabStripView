//
//  PagerSetFirstAppearItemModifier.swift
//  PagerTabStripView
//
//  Created by teq-macm1-073 on 27/09/2022.
//

import SwiftUI

struct PagerSetFirstAppearItemModifier: ViewModifier {

    private var onPageAppear: () -> Void

    init(onPageAppear: @escaping () -> Void) {
        self.onPageAppear = onPageAppear
    }

    func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onChange(of: dataStore.forcepdateIndex, perform: { _ in
                    DispatchQueue.main.async {
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        let newIndex = Int(round(frame.minX / self.settings.width))
                        if newIndex >= 0, newIndex < dataStore.itemsCount {
                            index = newIndex
                            dataStore.setFirstAppear(callback: onPageAppear, at: index)
                        }
                    }
                })
                .onAppear {
                    DispatchQueue.main.async {
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        let newIndex = Int(round(frame.minX / self.settings.width))
                        if dataStore.items[index] == nil {
                            index = newIndex
                            dataStore.setFirstAppear(callback: onPageAppear, at: index)
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
