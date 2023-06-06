//
//  BrowserWindowController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation
import AppKit

class BrowserWindowController: NSWindowController {
    
    weak var browsingContext: BrowsingContext?
    var browserContent: BrowserWindowContentController?
    var browserWindow: BrowserWindow?
    var windowMode: BrowsingMode?
    
    // TODO: Grab content mode from context
    init(browsingContext context: BrowsingContext?) {
        browsingContext = context
        browserWindow = BrowserWindow(browsingContext: context)
        browserContent = BrowserWindowContentController(contentMode: .startpage)
        windowMode = browsingContext?.mode
        super.init(window: browserWindow)
    }
    
    func configureContent() {
        browserWindow?.toolbar = BrowserToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
