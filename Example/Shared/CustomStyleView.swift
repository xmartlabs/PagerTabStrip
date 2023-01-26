//
//  CustomStyleView.swift
//  Example (iOS)
//
//  Created by Seyed Mojtaba Hosseini Zeidabadi on 3/11/22.
//

import SwiftUI
import PagerTabStripView

struct CustomStyleView: View {

    @State var selection = Color.blue

    private let 🌈: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple
    ]

    @MainActor var body: some View {
        PagerTabStripView(selection: $selection) {

            ForEach(🌈, id: \.self) { color in
                ZStack(alignment: .center) {
                    color
                    Text("Any custom View You like")
                }
                .pagerTabItem(tag: color) {
                    Capsule()
                        .frame(height: 32)
                        .padding(4)
                        .foregroundColor(color)
                }
            }
        }
        .pagerTabStripViewStyle(.barButton(placedInToolbar: false,
                                           pagerAnimation: .interactiveSpring(response: 0.5,
                                                                              dampingFraction: 1.00,
                                                                              blendDuration: 0.25),
                                           tabItemHeight: 48,
                                           barBackgroundView: {
            LinearGradient(
               colors: 🌈,
               startPoint: .topLeading,
               endPoint: .bottomTrailing
           )
           .opacity(0.2)
           .rotationEffect(even🌈.contains(selection) ? Angle(degrees: 0) : Angle(degrees: 180))
        }, indicatorView: {
            Text(even🌈.contains(selection) ? "👍🏻" : "👎").offset(x: 0, y: -24)
        }))
        .navigationTitle("🌈 Rainbow")
    }

    private let even🌈: [Color] = [.orange, .green, .purple]
}

struct CustomStyleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomStyleView()
    }
}
