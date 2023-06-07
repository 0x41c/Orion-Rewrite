//
//  UnifiedTabBarController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import AppKit

class UnifiedTabBarController: NSObject, ToolbarItemController {
    /// A cached display version of the tab bar, shown in the customization tray
    var displayTabBar: NSToolbarItem?
    /// The functional version of the tab bar made available by insertion.
    var insertableTabBar: NSToolbarItem?
    
    override init() {
        super.init()
    }
    
    
    // MARK: - ToolbarItemController
    
    static var itemIdentifier: NSToolbarItem.Identifier {
        NSToolbarItem.Identifier("UnifiedTabBar")
    }
    
    
    func getTrayDisplayableToolbarItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .init("UnifiedTabBar._displayTabBar"))
    }
    
    func getInsertableToolbarItem() -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier: .init("UnifiedTabBar._insertableTabBar"))
    }
    
    
}
