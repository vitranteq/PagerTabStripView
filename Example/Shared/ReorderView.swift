//
//  ReorderView.swift
//  Example (iOS)
//
//  Created by Phat Le on 27/09/2022.
//

import SwiftUI
import Combine
import PagerTabStripView

enum Tab: Hashable, CaseIterable {
    case blue
    case red
    case green
    case purple
    case yellow
    case setting

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
        case .setting:
            return "Setting"
        }
    }

    var color: Color {
        switch self {
        case .blue:
            return Color.blue
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .purple:
            return Color.purple
        case .yellow:
            return Color.yellow
        case .setting:
            return Color.clear
        }
    }
}

class ViewModel: ObservableObject, PagerTabStripReorderable {
    typealias TabItem = Tab

    @Published var originalTabs: [TabItem] = Tab.allCases
    @Published var tabs: [TabItem] = Tab.allCases
    @Published var isReordered = false
    @Published var selection = 2
    @Published var itemCountChange = false

    var cancellables = Set<AnyCancellable>()
    var hiddenTabs: [TabItem] = []

    init() {
        $originalTabs.receive(on: RunLoop.main)
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self else { return }

                self.updateTabs()
            }
            .store(in: &cancellables)
    }
}

struct ReorderView: View {
    private var swipeGestureEnabled: Bool

    @StateObject var viewModel = ViewModel()

    public init(swipeGestureEnabled: Bool = true) {
        self.swipeGestureEnabled = swipeGestureEnabled
    }

    var body: some View {
        PagerTabStripView(swipeGestureEnabled: swipeGestureEnabled,
                          selection: $viewModel.selection,
                          itemChange: $viewModel.itemCountChange) {
            ForEach(viewModel.tabs, id: \.self) { tab in
                makeTab(tab)
                    .pagerTabItem(needUpdate: $viewModel.isReordered) {
                        TwitterNavBarItem(title: tab.title)
                            .onPageAppear {
                                print("++++ \(tab) appear")
                            }
                    }
            }
        }
        .frame(alignment: .center)
        .pagerTabStripViewStyle(.scrollableBarButton(indicatorBarColor: .blue, tabItemSpacing: 15, tabItemHeight: 50))
    }

    @ViewBuilder
    func makeTab(_ tab: Tab) -> some View {
        switch tab {
        case .setting:
            OrderSetting(tabs: $viewModel.originalTabs) {
                viewModel.change(tab: $0, isOn: $1)
            }
        default:
            TabItem(tab: tab)
        }
    }
}

struct TabItem: View {
    let tab: Tab

    var body: some View {
        ScrollView {
            VStack {
                ForEach((1...50), id: \.self) {
                    Text("\($0)")
                        .frame(maxWidth: .infinity)
                        .frame(height: 33)
                }
            }
        }
        .background(tab.color)
    }
}

struct OrderSetting: View {
    @Binding var tabs: [Tab]
    var onChange: (Tab, Bool) -> Void

    init(
        tabs: Binding<[Tab]>,
        onChange: @escaping (Tab, Bool) -> Void
    ) {
        self._tabs = tabs
        self.onChange = onChange
    }

    var body: some View {
        List {
            ForEach(tabs, id: \.self) { tab in
                SettingItem(tab: tab) {
                    onChange($0, $1)
                }
            }
            .onMove(perform: changeTab(range:index:))
        }
    }

    func changeTab(range: IndexSet, index: Int) {
        tabs.move(fromOffsets: range, toOffset: index)
    }
}

struct SettingItem: View {
    let tab: Tab
    @State var isOn = true

    var onChange: (Tab, Bool) -> Void

    var body: some View {
        HStack {
            Text("\(tab.title)")
            Spacer()
            HStack {
                Toggle("", isOn: $isOn)
                Image(systemName: "line.horizontal.3")
            }
        }
        .onChange(of: isOn) { value in
            onChange(tab, value)
        }
    }
}
