//
//  YoutubeNavWithTitle.swift
//  Example (iOS)
//
//  Created by Milena Zabaleta on 6/22/21.
//

import Combine
import SwiftUI
import PagerTabStrip


let redColor = Color(red: 221/255.0, green: 0/255.0, blue: 19/255.0, opacity: 1.0)
let unselectedColor = Color(red: 73/255.0, green: 8/255.0, blue: 10/255.0, opacity: 1.0)
let selectedColor = Color(red: 234/255.0, green: 234/255.0, blue: 234/255.0, opacity: 0.7)

private class ButtonTheme: ObservableObject {
    @Published var backgroundColor = redColor
    @Published var textColor = unselectedColor
}

struct YoutubeNavWithTitle: View, PagerTabViewDelegate, Equatable {
    let title: String
    let imageName: String
    var image: Image {
        Image(imageName)
    }

    @ObservedObject fileprivate var theme = ButtonTheme()
    
    var body: some View {
        VStack {
            image
                .renderingMode(.template)
                .foregroundColor(theme.textColor)
            Text(title.uppercased())
                .foregroundColor(theme.textColor)
                .fontWeight(.regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundColor)
    }

    static func ==(lhs: YoutubeNavWithTitle, rhs: YoutubeNavWithTitle) -> Bool {
        return lhs.title == rhs.title
    }

    func setSelectedState(state: PagerTabViewState) {
        switch state {
        case .selected:
            self.theme.textColor = selectedColor
        default:
            self.theme.textColor = unselectedColor
        }
    }
}

struct YoutubeNavWithTitle_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeNavWithTitle(title: "Home", imageName: "home")
    }
}
