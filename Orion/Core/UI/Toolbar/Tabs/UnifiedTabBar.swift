//
//  UnifiedTabBar.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import AppKit

/// The tab bar, containing all of them tabs. At least... that's what I've been told. :thonk:
class UnifiedTabBar: NSView {
    /// The toolbar this tab bar is embedded into.
    weak var toolbarController: ToolbarController?
    /// The scroll view required for tab overflow/transitions.
    var scrollView: NSScrollView = NSScrollView()

    init(withToolbarController toolbar: ToolbarController?) {
        toolbarController = toolbar
        super.init(frame: .zero)

        // Constraints taken from safari.
        let views = ["UnifiedTabBar": self]
        var constraints: [NSLayoutConstraint] = []

        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:[UnifiedTabBar(>=320,<=10000)]",
            metrics: nil,
            views: views
        )
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:[UnifiedTabBar(28)]",
            metrics: nil,
            views: views
        )

        scrollView.hasHorizontalScroller = true
        scrollView.horizontalScroller = InvisibleScroller()
        scrollView.autohidesScrollers = false

        addSubview(scrollView)

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
