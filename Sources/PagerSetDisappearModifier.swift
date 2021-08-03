//
//  PagerSetDisappearModifier.swift
//  PagerTabStrip
//
//  Created by Cecilia Pirotto on 2/8/21.
//

import Foundation
import SwiftUI

struct PagerSetDisappearModifier: ViewModifier {

    private var onPageDisappear: () -> Void

    init(onPageDisappear: @escaping () -> Void) {
        self.onPageDisappear = onPageDisappear
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { reader in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.async {
                                let frame = reader.frame(in: .named("PagerViewScrollView"))
                                index = Int(round((frame.minX - settings.contentOffset) / settings.width))
                                dataStore.setDisappear(callback: onPageDisappear, at: index)
                            }
                        }
                }
            )
    }

    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @Environment(\.pagerTabViewStyle) var style: PagerTabViewStyle
    @State private var index = -1
}
