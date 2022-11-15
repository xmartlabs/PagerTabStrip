//
//  InstagramView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

struct InstagramView: View {
    
    enum Page {
        case gallery
        case list
        case like
        case saved
    }

    @State var selection = Page.list
    @State var toggle = true

    @ObservedObject var galleryModel = GalleryModel()
    @ObservedObject var listModel = ListModel()
    @ObservedObject var likedModel = LikedModel()
    @ObservedObject var savedModel = SavedModel()

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {
            PostsList(isLoading: $galleryModel.isLoading, items: galleryModel.posts).pagerTabItem(tag: Page.gallery) {
                InstagramNavBarItem(imageName: "gallery")
            }
            .onAppear {
                galleryModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    galleryModel.isLoading = false
                }
            }
            PostsList(isLoading: $listModel.isLoading, items: listModel.posts, withDescription: false).pagerTabItem(tag: Page.list) {
                InstagramNavBarItem(imageName: "list")
            }
            .onAppear {
                listModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    listModel.isLoading = false
                }
                }
            if toggle {
                PostsList(isLoading: $likedModel.isLoading, items: likedModel.posts).pagerTabItem(tag: Page.like) {
                    InstagramNavBarItem(imageName: "liked")
                }.onAppear {
                    likedModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        likedModel.isLoading = false
                    }
                }
                PostsList(isLoading: $savedModel.isLoading, items: savedModel.posts, withDescription: false).pagerTabItem(tag: Page.saved) {
                    InstagramNavBarItem(imageName: "saved")
                }.onAppear {
                    savedModel.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        savedModel.isLoading = false
                    }
                }
            }
        }
        .pagerTabStripViewStyle(.barButton(placedInToolbar: false, pagerAnimation: .default, tabItemHeight: 50, indicatorView: {
            Rectangle().fill(Color(.systemGray))
        }))
        .navigationBarItems(trailing: Button("Refresh") {
            toggle.toggle()
        })
    }
}

struct InstagramView_Previews: PreviewProvider {
    static var previews: some View {
        InstagramView()
    }
}
