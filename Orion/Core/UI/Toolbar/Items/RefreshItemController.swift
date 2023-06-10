//
//  RefreshItemController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-09.
//

import Foundation
import AppKit

class RefreshItemController: NSObject, ToolbarItemController {
    var parentToolbarController: ToolbarController?
    var itemIdentifier: NSToolbarItem.Identifier = .init("ReloadItem")
    var displayItem: NSToolbarItem?
    var activeItem: NSToolbarItem?
    
    /// The refresh image used in our active/display item.
    let refreshImage = NSImage(named: NSImage.refreshTemplateName)! // swiftlint:disable:this force_unwrapping

    required init(withToolbarController controller: ToolbarController?) {
        parentToolbarController = controller

        super.init()

        activeItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        activeItem?.paletteLabel = "Refresh Tab"
        activeItem?.image = refreshImage
        activeItem?.toolTip = "Refresh Tab"
        activeItem?.target = self
        activeItem?.action = #selector(reloadButtonClicked)
    }
    
    /// Refreshes the page when the ``activeItem`` is clicked.
    @objc func reloadButtonClicked() {
        browserSession?.sessionNavigationController?.reload()
    }
}
