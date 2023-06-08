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
    /// A reference to the parent toolbar controller. Useful for accessing browsing context.
    var parentToolbarController: ToolbarController? { get }
    /// A static identifier for the managed item
    var itemIdentifier: NSToolbarItem.Identifier { get }
    /// An optional item used for display in the customization sheet.
    var displayItem: NSToolbarItem? { get }
    /// An active item, configured by `getActiveToolbarItem`
    var activeItem: NSToolbarItem? { get }
    /// A lifecycle event triggered by a windows `ToolbarController`. The `activeItem` variable
    /// should be instantiated and configured when this method returns. If `displayItem` is `nil`,
    /// the `ToolbarController` will use the `activeItem` instead for display in the customization
    /// sheet.
    func configureItems()
    /// Creates an instance conforming to `ToolbarItemController`
    init(withToolbarController controller: ToolbarController?)
}
