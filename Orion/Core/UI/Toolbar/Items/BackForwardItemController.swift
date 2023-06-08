//
//  BackForwardItemController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import AppKit

class BackForwardItemController: NSObject, ToolbarItemController {
    weak var parentToolbarController: ToolbarController?
    var itemIdentifier: NSToolbarItem.Identifier = .init("BackForwardItem")
    var displayItem: NSToolbarItem?
    var activeItem: NSToolbarItem?
    
    func configureItems() {}
    
    required init(withToolbarController controller: ToolbarController?) {
        parentToolbarController = controller
    }
}
