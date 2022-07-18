//
//  BannerModifier.swift
//  PagerTabStripView
//
//  Created by teq-macm1-073 on 18/07/2022.
//

import SwiftUI

struct BannerModifier<BannerContent> : ViewModifier where BannerContent: View {
    @ViewBuilder private var bannerView: () -> BannerContent

    public init (bannerView: @escaping () -> BannerContent) {
        self.bannerView = bannerView
    }

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            bannerView()

            content
        }
    }
}
