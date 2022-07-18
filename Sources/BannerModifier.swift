//
//  HeaderModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct BannerModifier<BannerContent> : ViewModifier where BannerContent: View {
    private var selection: Int
    @ViewBuilder private var bannerView: () -> BannerContent

    public init (selection: Int, headerView: @escaping () -> BannerContent) {
        self.selection = selection
        self.bannerView = headerView
    }

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            bannerView()

            content
        }
    }

    @EnvironmentObject private var dataStore: DataStore
}
