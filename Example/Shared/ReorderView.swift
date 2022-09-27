//
//  ReorderView.swift
//  Example (iOS)
//
//  Created by Phat Le on 27/09/2022.
//

import SwiftUI
import PagerTabStripView

enum Tab: Hashable {
    case blue
    case red
    case green
    case purple
    case yellow

    var title: String {
        switch self {
        case .blue:
            return "Blue Blue"
        case .red:
            return "Red"
        case .green:
            return "Greeeen"
        case .purple:
            return "Purple Purple"
        case .yellow:
            return "Yellow"
        }
    }
}

class ViewModel: ObservableObject {
    @Published var tabs1: [Tab] = [.blue, .red, .green, .purple]
    @Published var isReordered = true
}

struct ReorderView: View {
    private var swipeGestureEnabled: Bool
    @State var selection = 2

    @StateObject var viewModel = ViewModel()

    public init(swipeGestureEnabled: Bool = true) {
        self.swipeGestureEnabled = swipeGestureEnabled
    }

    var body: some View {
        VStack {
            Button("Random order \(viewModel.isReordered ? "true" : "false")") {
//                let currentTab = viewModel.tabs1[selection]
                viewModel.tabs1.shuffle()
                print("view: \(viewModel.tabs1)")
//                selection = viewModel.tabs1.firstIndex(of: currentTab) ?? selection

                viewModel.isReordered.toggle()

            }
            PagerTabStripView(swipeGestureEnabled: swipeGestureEnabled, selection: $selection) {
                ForEach(viewModel.tabs1, id: \.self) { tab in
                    makeTab(tab)
                }
            }
            .frame(alignment: .center)
            .pagerTabStripViewStyle(.scrollableBarButton(indicatorBarColor: .blue, tabItemSpacing: 15, tabItemHeight: 50))
        }
    }

    @ViewBuilder
    func makeTab(_ tab: Tab) -> some View {
        makeContent(tab)
            .pagerTabItem(needUpdate: $viewModel.isReordered) {
                TwitterNavBarItem(title: tab.title)
            }.onPageAppear {
                print("++++ \(tab) appear")
            }
    }

    @ViewBuilder
    func makeContent(_ tab: Tab) -> some View {
        switch tab {
        case .blue:
            makeList()
                .background(Color.blue)
        case .red:
            makeList()
                .background(Color.red)
        case .green:
            makeList()
                .background(Color.green)
        case .purple:
            makeList()
                .background(Color.purple)
        case .yellow:
            makeList()
                .background(Color.yellow)
        }
    }

    @ViewBuilder
    func makeList() -> some View {
        ScrollView {
            VStack {
                ForEach((1...50), id: \.self) {
                    Text("\($0)")
                        .frame(maxWidth: .infinity)
                        .frame(height: 33)
                }
            }
        }
    }
}

