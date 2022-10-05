//
//  NavBarItem.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarItem: View {
    @EnvironmentObject private var dataStore: DataStore
    @Binding private var currentIndex: Int
    private var id: Int
    private var view: AnyView

    public init(id: Int, view: AnyView, selection: Binding<Int>) {
        self._currentIndex = selection
        self.id = id
        self.view = view
    }

    var body: some View {
        if id < dataStore.itemsCount {
            VStack {
                Button(action: {
                    self.currentIndex = id
                }, label: {
//                    dataStore.items[id]?.view
                    view
                }).buttonStyle(PlainButtonStyle())
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
                    dataStore.items[id]?.tabViewDelegate?.setState(state: pressing ? .highlighted :
                                                                    (id == currentIndex ? .selected : .normal))
                } perform: {}
            }.background(
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: dataStore.forcepdateIndex, perform: { newValue in
                            dataStore.items[id]?.itemWidth = geometry.size.width
                            let widthUpdated = dataStore.items.filter({ $0.value.itemWidth ?? 0 > 0 }).count == dataStore.itemsCount
                            dataStore.widthUpdated = dataStore.itemsCount > 0 && widthUpdated
                        })
                        .onAppear {
                        dataStore.items[id]?.itemWidth = geometry.size.width
                        let widthUpdated = dataStore.items.filter({ $0.value.itemWidth ?? 0 > 0 }).count == dataStore.itemsCount
                        dataStore.widthUpdated = dataStore.itemsCount > 0 && widthUpdated
                    }
                }
            )
        }
    }
}
