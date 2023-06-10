//
//  BrowserWindowController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-06.
//

import Foundation
import AppKit

/// Main window controller.
class BrowserWindowController: NSWindowController {
    /// Smallest the window should ever go, which is why this is static.
    /// Taken from observations of safari's minimum window behaviour.
    static var minimumWindowSize: NSSize {
        let safariMinWindowWidth = 575
        let safariMinWindowHeight = 200
        return NSSize(
            width: safariMinWindowWidth,
            height: safariMinWindowHeight
        )
    }
    /// Default content size. Don't need anything fancy here.
    static var launchWindowFrame: NSRect {
        let launchWidth = 1350
        let launchHeight = 780
        return NSRect(origin: .zero, size: NSSize(
            width: launchWidth,
            height: launchHeight
        ))
    }
    /// Context associated with this browsing session.
    weak var browserSession: BrowserSession?

    init(withSession session: BrowserSession) {
        browserSession = session
        super.init(window: NSWindow())
        window?.minSize = BrowserWindowController.minimumWindowSize
        window?.setFrame(BrowserWindowController.launchWindowFrame, display: true)
        window?.styleMask.insert([
            .closable, .miniaturizable, .resizable,
            .fullSizeContentView
        ])
        window?.titleVisibility = .hidden
    }

    required init(coder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
}
