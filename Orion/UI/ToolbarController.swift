//
//  ToolbarController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-06.
//

import Foundation
import AppKit

/// Controls the applications interface with the toolbar. Should
/// coordinate messages and update events from the window to the
/// tab items and likewise.
class ToolbarController: NSObject, NSToolbarDelegate {
    /// Reference to the window required for toolbar configuration
    weak var window: NSWindow?
    /// The managed reference to the toolbar.
    var toolbar: NSToolbar
    
    init(withWindow parentWindow: NSWindow?) {
        window = parentWindow
        toolbar = NSToolbar(identifier: "Orion Toolbar")
    }
    
    /// Configures the toolbar and assigns it to the window.
    func configureToolbar() {
        window?.toolbar = toolbar
        if #available(macOS 11, *) {
            window?.toolbarStyle = .unified
        } else {
            window?.toolbarStyle = .automatic
        }
        toolbar.delegate = self
        toolbar.allowsUserCustomization = true
        toolbar.autosavesConfiguration = true
        toolbar.displayMode = .iconOnly
    }
    
}
