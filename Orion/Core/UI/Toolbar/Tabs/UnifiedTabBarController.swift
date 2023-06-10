//
//  UnifiedTabBarController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import AppKit

/// A controller for the UnifiedTabBar view displayed in the toolbar.
class UnifiedTabBarController: NSObject, ToolbarItemController {
    weak var parentToolbarController: ToolbarController?
    var itemIdentifier: NSToolbarItem.Identifier = .init("UnifiedTabBar")
    var displayItem: NSToolbarItem?
    var activeItem: NSToolbarItem?

    /// The tab bar this class controls
    var unifiedTabBar: UnifiedTabBar?

    required init(withToolbarController controller: ToolbarController?) {
        parentToolbarController = controller
        super.init()
        configureDisplayItem()
        activeItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        unifiedTabBar = UnifiedTabBar(withToolbarController: parentToolbarController)
        activeItem?.view = unifiedTabBar
    }

    func configureDisplayItem() {
        displayItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        displayItem?.paletteLabel = "Address, Search, and Tabs"

        let addressViewFontSize = 16.0
        let tabViewFontSize = 17.0
        let addressViewIcon = NSTextField(labelWithString: "􀆪")
        let addressViewText = NSTextField(labelWithString: "Search or enter website name")
        let tabViewIcon = NSTextField(labelWithString: "")
        let tabViewText = NSTextField(labelWithString: "Apple")

        let addressView = NSStackView(views: [addressViewIcon, addressViewText])
        let tabView = NSStackView(views: [tabViewIcon, tabViewText])

        addressViewIcon.font = .systemFont(ofSize: addressViewFontSize, weight: .ultraLight)
        addressViewIcon.textColor = .secondaryLabelColor
        tabViewIcon.font = .systemFont(ofSize: tabViewFontSize)
        tabViewIcon.textColor = .secondaryLabelColor

        // NOTE: Apple does this differently; I'm sure they containerize two items
        // to allow them to take up the same amount of space.
        // swiftlint:disable:next no_magic_numbers
        let displayView = NSStackView(views: [addressView, tabView, NSView()])
        displayView.spacing = 60

        displayItem?.view = displayView
    }
}
