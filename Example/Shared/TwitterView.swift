//
//  TwitterView.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct TwitterView: View {
    @State var swipeGestureEnabled: Bool
    @State var selection = 2

    @ObservedObject var firstModel = TweetsModel()
    @ObservedObject var secondModel = MediaModel()
    @ObservedObject var thirdModel = LikesModel()
    @ObservedObject var fourthModel = TweetsModel()
    @ObservedObject var fifthModel = MediaModel()
    @ObservedObject var sixthModel = LikesModel()

    public init(swipeGestureEnabled: Bool = true) {
        self.swipeGestureEnabled = swipeGestureEnabled
    }

    @MainActor var body: some View {
        PagerTabStripView(swipeGestureEnabled: $swipeGestureEnabled, selection: $selection) {
            PostsList(isLoading: $firstModel.isLoading, items: firstModel.posts)
                .pagerTabItem {
                    TwitterNavBarItem(title: "First big width")
                }
            PostsList(isLoading: $secondModel.isLoading, items: secondModel.posts)
                .pagerTabItem {
                    TwitterNavBarItem(title: "Short")
                }
            PostsList(isLoading: $thirdModel.isLoading, items: thirdModel.posts, withDescription: false)
                .pagerTabItem {
                    TwitterNavBarItem(title: "Medium width")
                }
            PostsList(isLoading: $fourthModel.isLoading, items: fourthModel.posts)
                .pagerTabItem {
                    TwitterNavBarItem(title: "Second big width")
                }
            PostsList(isLoading: $fifthModel.isLoading, items: fifthModel.posts, withDescription: false)
                .pagerTabItem {
                    TwitterNavBarItem(title: "Medium width")
                }
            PostsList(isLoading: $sixthModel.isLoading, items: sixthModel.posts)
                .pagerTabItem {
                    TwitterNavBarItem(title: "Mini")
                }
        }
        .pagerTabStripViewStyle(.scrollableBarButton(placedInToolbar: false, tabItemSpacing: 15, tabItemHeight: 40, indicatorView: {
            Rectangle().fill(.blue).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
