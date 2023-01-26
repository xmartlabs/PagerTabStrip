//
//  TweetsModel.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import Foundation

class TweetsModel: ObservableObject {

    var posts: [Post] {
        PostsFactory.shared.posts
    }

    @Published var isLoading: Bool = false
}
