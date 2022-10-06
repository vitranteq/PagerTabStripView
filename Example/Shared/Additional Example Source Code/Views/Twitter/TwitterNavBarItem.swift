//
//  TwitterNav.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

private class TwitterNavBarModel: ObservableObject {
    @Published var textColor = Color.gray
    var isAppear = false

    deinit {
        print("+++++ theme deinit")
    }
}

struct TwitterNavBarItem: View, PagerTabViewDelegate {
    let title: String
    @ObservedObject fileprivate var model = TwitterNavBarModel()
    var onAppear: () -> Void = {}

    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(model.textColor)
                .font(.subheadline)
        }
        .background(Color.clear)
        .onChange(of: model.isAppear) { isAppear in
            if isAppear {
                onAppear()
            }
        }
    }

    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.model.textColor = .blue
            model.isAppear = true
        case .highlighted:
            self.model.textColor = .red
        default:
            self.model.textColor = .gray
            model.isAppear = false
        }
    }

    func onPageAppear(_ action: @escaping () -> Void) -> Self {
        var _self = self
        _self.onAppear = action
        return _self
    }
}

struct TwitterNavBarItem_Previews: PreviewProvider {
    static var previews: some View {
        TwitterNavBarItem(title: "Tweets")
    }
}
