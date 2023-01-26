//
//  PagerTabStripView.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//
import SwiftUI

class PagerSettings: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
}

@available(iOS 14.0, *)
public struct PagerTabStripView<Content>: View where Content: View {
    private var content: () -> Content
    private var swipeGestureEnabled: Binding<Bool>
    private var selection: Binding<Int>?
    @State private var selectionState = 0
    @StateObject private var settings: PagerSettings

    public init(swipeGestureEnabled: Binding<Bool> = .constant(true), selection: Binding<Int>? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.swipeGestureEnabled = swipeGestureEnabled
        self.selection = selection
        self.content = content
        self._settings = StateObject(wrappedValue: PagerSettings())
    }

    @MainActor public var body: some View {
        WrapperPagerTabStripView(swipeGestureEnabled: swipeGestureEnabled, selection: selection ?? $selectionState, content: content)
            .environmentObject(settings)
    }
}

private struct WrapperPagerTabStripView<Content>: View where Content: View {

    private var content: () -> Content

    @StateObject private var dataStore = DataStore()
    @Environment(\.pagerStyle) var style: PagerStyle
    @EnvironmentObject private var settings: PagerSettings
    @Binding var selection: Int {
        didSet {
            if selection < 0 { selection = oldValue }
        }
    }
    @State private var currentOffset: CGFloat = 0 {
        didSet { settings.contentOffset = currentOffset }
    }
    @GestureState private var translation: CGFloat = 0
    @Binding private var swipeGestureEnabled: Bool

    public init(swipeGestureEnabled: Binding<Bool>, selection: Binding<Int>, @ViewBuilder content: @escaping () -> Content) {
        self._swipeGestureEnabled = swipeGestureEnabled
        self._selection = selection
        self.content = content
    }

    @MainActor public var body: some View {
        GeometryReader { gproxy in
            LazyHStack(spacing: 0) {
                content()
                    .frame(width: gproxy.size.width)
            }
            .coordinateSpace(name: "PagerViewScrollView")
            .offset(x: -CGFloat(selection) * gproxy.size.width)
            .offset(x: translation)
            .animation(style.pagerAnimation, value: selection)
            .animation(.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25), value: translation)
            .gesture(!swipeGestureEnabled ? nil :
                DragGesture(minimumDistance: 25).updating(self.$translation) { value, state, _ in
                    if selection == 0 && value.translation.width > 0 {
                        let valueWidth = value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = gproxy.size.width/1.5 * logValue
                    } else if selection == dataStore.itemsCount - 1 && value.translation.width < 0 {
                        let valueWidth = -value.translation.width
                        let normTrans = valueWidth / (gproxy.size.width + 50)
                        let logValue = log(1 + normTrans)
                        state = -gproxy.size.width / 1.5 * logValue
                    } else {
                        state = value.translation.width
                    }
                }.onEnded { value in
                    let offset = value.predictedEndTranslation.width / gproxy.size.width
                    let newPredictedIndex = (CGFloat(selection) - offset).rounded()
                    let newIndex = min(max(Int(newPredictedIndex), 0), dataStore.itemsCount - 1)
                    if abs(selection - newIndex) > 1 {
                        selection = newIndex > selection ? selection + 1 : selection - 1
                    } else {
                        selection = newIndex
                    }
                    if translation > 0 {
                        currentOffset = translation
                    }
                }
            }.onEnded { value in
                let offset = value.predictedEndTranslation.width / gproxy.size.width
                let newPredictedIndex = (CGFloat(selection) - offset).rounded()
                let newIndex = min(max(Int(newPredictedIndex), 0), dataStore.itemsCount - 1)
                if abs(selection - newIndex) > 1 {
                    selection = newIndex > selection ? selection + 1 : selection - 1
                } else {
                    selection = newIndex
                }
                if translation > 0 {
                    self.currentOffset = translation
                }
            })
            .onAppear(perform: {
                let geo = gproxy.frame(in: .local)
                settings.width = geo.width
                currentOffset = -(CGFloat(selection) * geo.width)
            })
            .onChange(of: gproxy.frame(in: .local), perform: { geo in
                settings.width = geo.width
                currentOffset = -(CGFloat(selection) * geo.width)
            })
            .onChange(of: selection) { [selection] newIndex in
                currentOffset = -(CGFloat(newIndex) * gproxy.size.width)
                dataStore.items[newIndex]?.appearCallback?()
                dataStore.items[selection]?.tabViewDelegate?.setState(state: .normal)
                if let tabViewDelegate = dataStore.items[newIndex]?.tabViewDelegate, newIndex != selection {
                    tabViewDelegate.setState(state: .selected)
                }
            }
            .onChange(of: translation) { _ in
                settings.contentOffset = translation - CGFloat(selection)*gproxy.size.width
            }
            .onChange(of: dataStore.itemsCount) { _ in
                selection = selection >= dataStore.itemsCount ? dataStore.itemsCount - 1 : selection
                dataStore.items[selection]?.tabViewDelegate?.setState(state: .selected)
                dataStore.items[selection]?.appearCallback?()
            }
        }
        .modifier(NavBarModifier(selection: $selection))
        .environmentObject(dataStore)
        .clipped()
    }

}
