//
//  PagerTabItemModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct PagerTabItemModifier<NavTabView: View>: ViewModifier {

    private var navTabView: () -> NavTabView
    @Binding var needUpdate: Bool

    init(needUpdate: Binding<Bool> = .constant(false), navTabView: @escaping () -> NavTabView) {
        self.navTabView = navTabView
        self._needUpdate = needUpdate
    }

    func body(content: Content) -> some View {
        GeometryReader { reader in
            content
                .onAppear {
                    DispatchQueue.main.async {
                        setItemView(from: reader)
                    }
                }
                .onDisappear {
                    dataStore.items[index]?.tabViewDelegate?.setState(state: .normal)
                    dataStore.remove(at: index)
                }
                .onChange(of: needUpdate) { _ in
                    DispatchQueue.main.async {
                        setItemView(from: reader)
                    }
                }
        }
    }

    func setItemView(from proxy: GeometryProxy) {
        let frame = proxy.frame(in: .named("PagerViewScrollView"))
        index = Int(round(frame.minX / self.settings.width))
        let tabView = navTabView()
        let tabViewDelegate = tabView as? PagerTabViewDelegate
        dataStore.setView(AnyView(tabView), at: index)
        dataStore.setTabViewDelegate(tabViewDelegate, at: index)

        // render navbar if needed
        dataStore.forceUpdate = needUpdate
    }

    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var settings: PagerSettings
    @State private var index = -1
}
