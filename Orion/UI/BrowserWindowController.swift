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
        NSSize(width: 575, height: 700)
    }
    /// Context associated with this browsing session. Dictates certain
    /// window/sub-controller behaviours, such as history recognition (not implemented).
    weak var browsingContext: BrowsingContext?
    var tabContentController: TabContentViewController
    
    init(withContext context: BrowsingContext) {
        browsingContext = context
        tabContentController = TabContentViewController(withContext: context)
        super.init(window: nil)
    }
    
    required init(coder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Does basic window configuration and makes the window presentable.
    /// Additionally ensures tab content has been created.
    func configureWindow() {
        window?.minSize = BrowserWindowController.minimumWindowSize
        window?.styleMask.insert([
            .closable, .miniaturizable, .resizable,
            .fullSizeContentView
        ])
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        contentViewController = tabContentController
    }
    
}
