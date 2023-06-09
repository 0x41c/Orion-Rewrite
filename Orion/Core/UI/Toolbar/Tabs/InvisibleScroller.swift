//
//  InvisibleScroller.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import AppKit

/// An invisible scrollbar for the ``UnifiedTabBar``'s `scrollView`
class InvisibleScroller: NSScroller {
    static override func scrollerWidth(
        for controlSize: NSControl.ControlSize,
        scrollerStyle: NSScroller.Style
    ) -> CGFloat {
        return 0.0
    }
}
