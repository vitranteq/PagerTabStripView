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
                .onAppear {
                    DispatchQueue.main.async {
                        let frame = reader.frame(in: .named("PagerViewScrollView"))
                        index = Int(round(frame.minX / self.settings.width))
                        dataStore.setFirstAppear(callback: onPageAppear, at: index)
                    }
                }
            }
    }

    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @Environment(\.pagerStyle) var style: PagerStyle
    @State private var index = -1
}
