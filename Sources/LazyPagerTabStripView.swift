//
//  LazyPagerTabStripView.swift
//  PagerTabStripView
//
//  Created by teq-macm116g-01 on 10/10/2022.
//

import SwiftUI

@available(iOS 14.0, *)
public struct LazyPagerTabStripView<Content, T>: View where T: Hashable, Content: View {
    @Binding private var selection: Int
    private var pages: [T]
    private let itemView: (T, Bool) -> Content
    @State private var appearTabStack: [T: Bool] = [:]
    private var onFirstAppear: ((T) -> Void)?

    public init(
        selection: Binding<Int>,
        pages: [T],
        @ViewBuilder item: @escaping (T, Bool) -> Content
    ) {
        self.pages = pages
        self.itemView = item
        self._selection = selection
    }

    public var body: some View {
        PagerTabStripView(selection: $selection) {
            ForEach(pages, id: \.self) { tab in
                itemView(tab, appearTabStack[tab] == true)
                    .modifier(
                        PagerSetFirstAppearItemModifier {
                            handleFirstAppear(tab)
                        }
                    )
            }
        }
    }

    func handleFirstAppear(_ tab: T) {
        guard appearTabStack[tab] == nil else { return }
        appearTabStack[tab] = true
    }
}
