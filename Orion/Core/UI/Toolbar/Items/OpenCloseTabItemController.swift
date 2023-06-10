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

    // swiftlint:disable force_unwrapping
    /// The "+" image for the open tab button.
    let openImage: NSImage = NSImage(named: NSImage.addTemplateName)!
    /// The "x" image for the close tab button.
    let closeImage: NSImage = NSImage(named: NSImage.stopProgressTemplateName)!
    // swiftlint:enable force_unwrapping

    required init(withToolbarController controller: ToolbarController?) {
        parentToolbarController = controller

        super.init()

        activeItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        activeItem?.paletteLabel = "Open/Close Tab"
        let segmentedControl = NSSegmentedControl(
            images: [openImage, closeImage],
            trackingMode: .momentary,
            target: self,
            action: #selector(openCloseSegmentClicked)
        )

        segmentedControl.setToolTip("New Tab", forSegment: 0)
        segmentedControl.setToolTip("Close Tab", forSegment: 1)

        activeItem?.view = segmentedControl
    }

    /// The action handler for the active item's open and close buttons
    @objc func openCloseSegmentClicked(_ control: NSSegmentedControl) {
        switch control.selectedSegment {
        case 0:
            browserSession?.openTab()

        case 1:
            browserSession?.closeTab()

        default: Logger.error("Cosmic bit flip; This should be 0.")
        }
    }
}
