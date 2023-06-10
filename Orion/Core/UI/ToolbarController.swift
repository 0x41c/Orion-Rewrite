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
    /// This toolbars browsing session.
    weak var browserSession: BrowserSession?
    /// The managed reference to the toolbar.
    var toolbar: NSToolbar
    /// The tab bar item.
    var tabBarController: UnifiedTabBarController?
    /// The back and forward buttons.
    var backForwardController: BackForwardItemController?
    /// The open/close buttons. The close button exists for debugging purposes and may be
    /// removed later.
    var openCloseTabController: OpenCloseTabItemController?
    /// The refresh tab button.
    var refreshTabController: RefreshItemController?
    
    /// A list of all the toolbar items; Lazily initializes them.
    lazy var itemControllers: [ToolbarItemController] = {
        backForwardController = BackForwardItemController(withToolbarController: self)
        tabBarController = UnifiedTabBarController(withToolbarController: self)
        openCloseTabController = OpenCloseTabItemController(withToolbarController: self)
        refreshTabController = RefreshItemController(withToolbarController: self)
        // swiftlint:disable force_unwrapping
        return [backForwardController!,
                tabBarController!,
                openCloseTabController!,
                refreshTabController!]
        // swiftlint:enable force_unwrapping
    }()
    /// A map of the items to their identifiers. Useful for later retrieval.
    var toolbarItemMap: [NSToolbarItem.Identifier: ToolbarItemController] {
        .init(uniqueKeysWithValues: zip(itemControllers.map({ $0.itemIdentifier }), itemControllers))
    }

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

    init(withSession session: BrowserSession) {
        browserSession = session
        toolbar = NSToolbar(identifier: "Orion Toolbar")
        super.init()

        // swiftlint:disable force_unwrapping
        guard session.sessionController != nil,
              let window = session.sessionController!.window else {
            Logger.error("Invalid session passed to ToolbarController")
        }
        // swiftlint:enable force_unwrapping

        window.toolbar = toolbar
        if #available(macOS 11, *) {
            window.toolbarStyle = .unified
        }
        toolbar.delegate = self
        toolbar.allowsUserCustomization = true
        toolbar.autosavesConfiguration = true
        toolbar.displayMode = .iconOnly
    }

    // MARK: - NSToolbarDelegate

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarItemIdentifiers
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarItemIdentifiers
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemIdentifier: NSToolbarItem.Identifier,
        canBeInsertedAt index: Int
    ) -> Bool {
        true
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        let item = toolbarItemMap[itemIdentifier]
        if flag {
            return item?.activeItem
        }
        return item?.displayItem ?? item?.activeItem
    }
}
