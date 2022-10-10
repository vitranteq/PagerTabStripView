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
                .onChange(of: dataStore.forceUpdate) { _ in
                    DispatchQueue.main.async {
                        if let newIndex = getIndex(reader),
                            newIndex >= 0,
                            newIndex < dataStore.itemsCount {
                            dataStore.setAppear(callback: onPageAppear, at: newIndex)
                            index = newIndex
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        if let index = getIndex(reader) {
                            dataStore.setAppear(callback: onPageAppear, at: index)
                            self.index = index
                        }
                    }
                }
        }
    }

    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @Environment(\.pagerStyle) var style: PagerStyle
    @State private var index = -1
    
    private func getIndex(_ reader: GeometryProxy) -> Int? {
        let frame = reader.frame(in: .named("PagerViewScrollView"))
        guard frame != .zero else { return nil }
        return Int(round(frame.minX / self.settings.width))
    }
}
