//
//  PagerTabViewDelegate.swift
//  PagerTabStripView
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

public enum PagerTabViewState {
    case selected
    case highlighted
    case normal
}

public protocol PagerTabViewDelegate {
    func setState(state: PagerTabViewState)
}
