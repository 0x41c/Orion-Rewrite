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
    /// As with the last project, this is also taken from safari.
    static var minimumWindowSize: NSSize {
        NSSize(width: 575, height: 200)
    }
    /// Default content size. Don't need anything fancy here
    static var launchWindowFrame: NSRect {
        NSRect(origin: .zero, size: NSSize(
            width: 1000,
            height: 600
        ))
    }
    /// Context associated with this browsing session. Dictates certain window/sub-controller
    /// behaviours, such as history recognition (not implemented).
    weak var browsingContext: BrowserSessionContext?
    /// Content controller hosting a webview and supporting API's
    var tabContentController: TabContentViewController
    var toolbarController: ToolbarController
    
    init(withContext context: BrowserSessionContext) {
        let window = NSWindow()
        browsingContext = context
        tabContentController = TabContentViewController(withContext: context)
        toolbarController = ToolbarController()
        super.init(window: window)
        contentViewController = tabContentController
    }
    
    required init(coder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Does basic window configuration and makes the window presentable. Additionally ensures
    /// tab and toolbar content have been instantiated and configured.
    func configureWindow() {
        window?.minSize = BrowserWindowController.minimumWindowSize
        window?.styleMask.insert([
            .closable, .miniaturizable, .resizable,
            .fullSizeContentView
        ])
        window?.titleVisibility = .hidden
        toolbarController.configureToolbar(inWindow: window)
        window?.setFrame(
            BrowserWindowController.launchWindowFrame,
            display: true
        )
        window?.center()
    }
    
}
