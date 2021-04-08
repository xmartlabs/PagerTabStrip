//
//  XLPagerView.swift
//  PagerTabStrip
//
//  Created by Manuel Lorenze on 7/22/20.
//

import SwiftUI

struct PagerTabView<Content : View, NavTabView : View> : View {

    @EnvironmentObject var navContentViews : PagerTabInfo
    var content: () -> Content
    var navTabView : () -> NavTabView
    var title: String

    init(title: String, @ViewBuilder navTabView: @escaping () -> NavTabView ,@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.navTabView = navTabView
        self.title = title
    }

    var body: some View {
        content().onAppear {
            navContentViews.item = title
        }
    }
}

struct PagerTabItem<NavTabView: View> : ViewModifier {

    var navTabView: () -> NavTabView
    var title: String

    init(title: String, navTabView: @escaping () -> NavTabView) {
        self.navTabView = navTabView
        self.title = title
    }

    func body(content: Content) -> some View {
        PagerTabView(title: title, navTabView: navTabView) {
            content
        }
    }
}

extension View {
    public func pagerTabItem<V>(title: String, @ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where V : View {
        return self.modifier(PagerTabItem(title: title, navTabView: pagerTabView))
    }
}


struct NavBar: View {

    @EnvironmentObject var navContentViews : PagerTabInfo
    @State private var nextIndex = 0
    @Binding private var indexSelected: Int
    private var id: Int
    
    public init(id: Int, selection: Binding<Int>) {
        self._indexSelected = selection
        self.id = id
    }
    
    var body: some View {
        HStack(){
            if #available(iOS 14.0, *) {
                Button("Go To \(self.nextIndex + 1) \(navContentViews.item)") {
                    self.indexSelected = nextIndex
                }
                .onChange(of: self.indexSelected) { value in
                    let newIndex = Int.random(in: 0..<5)
                    self.nextIndex = newIndex
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

public enum PagerType {
    case twitter
    case youtube
}


public class PagerTabInfo: ObservableObject {
    @Published var item: String = "Chechu"
}


@available(iOS 14.0, *)
public struct XLPagerView<Content> : View where Content : View {

    @StateObject var navContentViews = PagerTabInfo()

    private var type: PagerType
    private var content: () -> Content
    
    @State private var currentIndex: Int
    @State private var currentOffset: CGFloat = 0
    
    @State private var pageWidth : CGFloat = 0
    @State private var contentWidth : CGFloat = 0
    @State private var itemCount : Int = 0
    @State var dragOffset : CGFloat = 0


    public init(_ type: PagerType = .twitter,
                selection: Int = 0,
                @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
        self._currentIndex = State(initialValue: selection)
    }
    
    func offsetForPageIndex(_ index: Int) -> CGFloat {
        return (CGFloat(index) * pageWidth) * -1.0
    }
    
    func indexPageForOffset(_ offset : CGFloat) -> Int {
        guard self.itemCount > 0 else {
            return 0
        }
        let floatIndex = (offset * -1) / pageWidth
        var computedIndex = Int(round(floatIndex))
        computedIndex = max(computedIndex, 0)
        return min(computedIndex, self.itemCount - 1)
    }
    
    public var body: some View {
        VStack {
            if type == .youtube {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 5) {
                        NavBar(id: 0, selection: $currentIndex)
                            .frame(width: 100, height: 40, alignment: .center)
                            .background(Color.red)
                        NavBar(id: 1, selection: $currentIndex)
                            .frame(width: 100, height: 40, alignment: .center)
                            .background(Color.red)
                        NavBar(id: 2, selection: $currentIndex)
                            .frame(width: 100, height: 40, alignment: .center)
                            .background(Color.red)
                    }
                }
            }
            GeometryReader { gproxy in
                ScrollViewReader { sproxy in
                    ScrollView(.horizontal) {
                        ZStack(alignment: .leading){
                            LazyHStack(spacing: 0) {
                                self.content().frame(width: gproxy.size.width,
                                                     height: gproxy.size.height,
                                                     alignment: .center)
                            }
                            .offset(x: self.currentOffset)
                            .animation(.interactiveSpring())
                            .gesture( DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged { value in
                                    let previousTranslation = self.dragOffset
                                    self.currentOffset += value.translation.width - previousTranslation
                                    self.dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    let dragged = value.translation.width
                                    if dragged < 0 {
                                        self.currentIndex = min(self.currentIndex + 1, self.itemCount - 1)
                                        if self.currentIndex == self.itemCount - 1 {
                                            self.currentOffset = self.offsetForPageIndex(self.itemCount - 1)
                                            self.dragOffset = 0
                                        }
                                    } else if self.dragOffset > 0 {
                                        self.currentIndex = max(self.currentIndex - 1, 0)
                                        if currentIndex == 0 {
                                            self.currentOffset = 0
                                            self.dragOffset = 0
                                        }
                                    }
                                }
                            )
                            GeometryReader { pproxy in
                                Color.clear.frame(width: 10, height: 10, alignment: .leading)
                                    .onAppear {
                                        self.currentOffset = pproxy.frame(in: .local).minX
                                        self.contentWidth = pproxy.frame(in: .local).width
                                    }
                            }
                        }
                    }
                    .onChange(of: self.currentIndex) { index in
                        self.currentOffset = self.offsetForPageIndex(self.currentIndex)
                        self.dragOffset = 0
                        withAnimation {
                            sproxy.scrollTo(index)
                        }
                    }
                }
                .onAppear {
                    self.pageWidth = gproxy.size.width
                    self.itemCount = Int(round(self.contentWidth / self.pageWidth))
                }
            }
            HStack {
                Text("Offset: \(self.currentOffset) Page: \(self.currentIndex + 1)")
            }
        }.environmentObject(self.navContentViews)
    }
}
