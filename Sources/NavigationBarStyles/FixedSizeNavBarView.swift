//
//  FixedSizeNavBarView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation
import SwiftUI

internal struct FixedSizeNavBarView<BG: View>: View {
    @Binding private var selection: Int
    @EnvironmentObject private var dataStore: DataStore
    private var backgroundView: BG
    public init(selection: Binding<Int>, background: () -> BG) {
        self._selection = selection
        self.backgroundView = background()
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            HStack(spacing: internalStyle.tabItemSpacing) {
                ForEach(dataStore.itemsOrderedByIndex) { item in
                    NavBarItem(id: item.id, selection: $selection)
                        .frame(height: internalStyle.tabItemHeight)
                        .tag(item.id)
                }
            }
            .frame(height: internalStyle.tabItemHeight)
            .background(backgroundView)
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
}
