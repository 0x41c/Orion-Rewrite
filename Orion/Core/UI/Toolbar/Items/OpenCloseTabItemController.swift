//
//  OpenCloseTabItemController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-08.
//

import Foundation
import AppKit

class OpenCloseTabItemController: NSObject, ToolbarItemController {
    var parentToolbarController: ToolbarController?
    var itemIdentifier: NSToolbarItem.Identifier = .init("OpenCloseTabItem")
    var displayItem: NSToolbarItem?
    var activeItem: NSToolbarItem?
    
    func configureItems() {
        
    }
    
    required init(withToolbarController controller: ToolbarController?) {
        parentToolbarController = controller
    }
    
    
}
