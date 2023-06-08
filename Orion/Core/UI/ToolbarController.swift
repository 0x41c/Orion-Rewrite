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
    /// Browsing context for this toolbar.
    weak var sessionContext: BrowserSessionContext?
    /// The managed reference to the toolbar.
    var toolbar: NSToolbar
    /// The tab bar item.
    var tabBarController: UnifiedTabBarController?
    
    lazy var itemControllers: [ToolbarItemController] = {
       return [
            BackForwardItemController(withToolbarController: self),
            UnifiedTabBarController(withToolbarController: self)
        ]
    }()
    
    /// A list of item identifiers to display in the toolbar
    var toolbarItemIdentifiers: [NSToolbarItem.Identifier] {
        itemControllers.map { controller in
            controller.itemIdentifier
        }
    }
    /// A list if item identifiers to display in the default group
    var defaultItemIdentifiers: [NSToolbarItem.Identifier] {
        toolbarItemIdentifiers
    }
    
    init(withContext context: BrowserSessionContext) {
        toolbar = NSToolbar(identifier: "Orion Toolbar")
        super.init()
    }
    
    /// Configures the toolbar and assigns it to the window.
    func configureToolbar(inWindow window: NSWindow?) {
        window?.toolbar = toolbar
        if #available(macOS 11, *) {
            window?.toolbarStyle = .unified
        }
        toolbar.delegate = self
        toolbar.allowsUserCustomization = true
        toolbar.autosavesConfiguration = true
        toolbar.displayMode = .iconOnly
    }
    
    // MARK: - NSToolbarDelegate
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItemIdentifiers
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarItemIdentifiers
    }
    
    func toolbar(_ toolbar: NSToolbar, itemIdentifier: NSToolbarItem.Identifier, canBeInsertedAt index: Int) -> Bool {
        return true
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        return nil
    }
    
}
