//
//  BrowserWindow.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation
import AppKit

class BrowserWindow : NSWindow {
    
    weak var browsingContext: BrowsingContext?
    
    // TODO: Grab window designated values from context
    init(browsingContext context: BrowsingContext?) {
        browsingContext = context
        super.init(contentRect: .zero, styleMask: .unifiedTitleAndToolbar, backing: .buffered, defer: true)
    }
    
    
}
