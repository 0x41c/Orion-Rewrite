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
    /// The segmented control for this controllers ``activeItem``
    var segmentedControl: NSSegmentedControl?
    /// The observer for the segmented controls state updates.
    var locationDidChangeObserver: BrowserNavigationController.Certificate?
    /// The navigation controller used to direct the webview back/forward in it's history
    var navigationController: BrowserNavigationController? {
        browserSession?.sessionNavigationController
    }
    /// Images used for the controls
    var segmentImages: [NSImage] {
        guard let backImage = NSImage(named: NSImage.goBackTemplateName),
              let forwardImage = NSImage(named: NSImage.goForwardTemplateName) else {
            Logger.error("They did it. They removed the back/forward template images. Consider upgrading to WindowsOS")
        }
        return [backImage, forwardImage]
    }

    required init(withToolbarController controller: ToolbarController?) {
        parentToolbarController = controller

        super.init()

        displayItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        displayItem?.paletteLabel = "Back/Forward"

        let displayControl = NSSegmentedControl(
            images: segmentImages,
            trackingMode: .momentary,
            target: nil,
            action: nil
        )

        displayControl.segmentStyle = .separated

        displayItem?.view = displayControl

        activeItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        if #available(macOS 11, *) {
            activeItem?.isNavigational = true
        }

        segmentedControl = NSSegmentedControl(
            images: segmentImages,
            trackingMode: .momentary,
            target: self,
            action: #selector(backForwardClicked)
        )

        segmentedControl?.setToolTip("Back", forSegment: 0)
        segmentedControl?.setToolTip("Forward", forSegment: 1)

        activeItem?.view = segmentedControl

        locationDidChangeObserver = navigationController?.registerObserver(
            .locationDidChange,
            withTarget: self,
            selector: #selector(locationDidChange)
        )
        
        // swiftlint:disable:next force_unwrapping
        updateItemVisibilities(forControl: segmentedControl!)
    }

    /// The observer callback for ``TabSession``'s "`locationDidChange`" event. Delegates
    /// to ``updateItemVisibilities(forControl:)``.
    @objc func locationDidChange() {
        // swiftlint:disable:next force_unwrapping
        updateItemVisibilities(forControl: segmentedControl!)
    }

    /// Updates the segments in ``segmentedControl`` depending on the context's ability
    /// to navigate through web history.
    func updateItemVisibilities(forControl control: NSSegmentedControl) {
        guard navigationController != nil,
              let canGoBack = navigationController?.canGoBack,
              let canGoForward = navigationController?.canGoForward else {
            Logger.error("Attempting to update navigation peripherals without a navigation controller.")
        }

        control.setEnabled(canGoBack, forSegment: 0)
        control.setEnabled(canGoForward, forSegment: 1)
    }

    /// The action handler for the active item's back and forward buttons.
    @objc func backForwardClicked(_ control: NSSegmentedControl) {
        switch control.selectedSegment {
        case 0:
            navigationController?.goBack()
            // FIXME: Webkit doesn't send a completion for backwards navigation so the timing is wrong.
            updateItemVisibilities(forControl: control)

        case 1:
            navigationController?.goForward()

        default: Logger.error("Proof that P=NP?")
        }
    }
}
