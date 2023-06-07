//
//  ToolbarItemController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import AppKit

/// A utility-ish protocol to simplify delegation of toolbar item creation. Encourages the caching of items
/// for state responsiveness.
protocol ToolbarItemController: NSObject {
    /// A static identifier for the managed item
    static var itemIdentifier: NSToolbarItem.Identifier { get }
    /// Should create and return a toolbar item purely for display purposes in the customization tray
    func getTrayDisplayableToolbarItem() -> NSToolbarItem
    /// Should create and return an insertable toolbar item available for use.
    func getInsertableToolbarItem() -> NSToolbarItem
}
