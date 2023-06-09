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
    
    func configureItems() {
        configureDisplayItem()
        activeItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        unifiedTabBar = UnifiedTabBar(withToolbarController: parentToolbarController)
        unifiedTabBar?.configureTabs()
        activeItem?.view = unifiedTabBar
    }
    
    func configureDisplayItem() {
        displayItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        displayItem?.paletteLabel = "Address, Search, and Tabs"
        
        let addressViewIcon = NSTextField(labelWithString: "􀆪")
        let addressViewText = NSTextField(labelWithString: "Search or enter website name")
        let tabViewIcon = NSTextField(labelWithString: "")
        let tabViewText = NSTextField(labelWithString: "Apple")
        
        let addressView = NSStackView(views: [addressViewIcon, addressViewText])
        let tabView = NSStackView(views: [tabViewIcon, tabViewText])
        
        addressViewIcon.font = .systemFont(ofSize: 16, weight: .ultraLight)
        addressViewIcon.textColor = .secondaryLabelColor
        tabViewIcon.font = .systemFont(ofSize: 17)
        tabViewIcon.textColor = .secondaryLabelColor
        
        let displayView = NSStackView(views: [addressView, tabView])
        
        // NOTE: Apple does this differently; I'm sure they containerize the items
        // to allow them to take up the same amount of space.
        displayView.spacing = 60
        
        displayItem?.view = displayView
    }
    
    required init(withToolbarController controller: ToolbarController?) {
      parentToolbarController = controller
    }
}
