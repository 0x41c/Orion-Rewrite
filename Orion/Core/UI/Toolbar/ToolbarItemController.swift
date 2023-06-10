//
//  ToolbarItemController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import AppKit

/// A utility-ish protocol to simplify delegation of toolbar item creation. Encourages the caching
/// of items for state responsiveness.
protocol ToolbarItemController: NSObject {
    /// A reference to the parent toolbar controller.
    var parentToolbarController: ToolbarController? { get }
    /// A reference to the session context.
    var browserSession: BrowserSession? { get }
    /// A static identifier for the managed item
    var itemIdentifier: NSToolbarItem.Identifier { get }
    /// An optional item used for display in the customization sheet.
    var displayItem: NSToolbarItem? { get }
    /// An active item.
    var activeItem: NSToolbarItem? { get }
    /// Creates an instance conforming to `ToolbarItemController`
    init(withToolbarController controller: ToolbarController?)
    /// An update event fired when about to move into the toolbar for final checks
}

extension ToolbarItemController {
    var browserSession: BrowserSession? {
        parentToolbarController?.browserSession
    }
}
