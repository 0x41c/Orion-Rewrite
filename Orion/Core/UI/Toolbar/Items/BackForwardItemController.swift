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
    
    /// Images used for the controls
    let segmentImages: [NSImage] = [
        // Trust me, these won't be going any time soon ;)
        NSImage(named: NSImage.goBackTemplateName)!,
        NSImage(named: NSImage.goForwardTemplateName)!
    ]
    
    required init(withToolbarController controller: ToolbarController?) {
        parentToolbarController = controller
    }
    
    func configureItems() {
        configureDisplayItem()
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
        
        sessionContext?.currentTabContext?.registerContextObserver(
            target: self,
            selector: #selector(locationDidChange),
            event: .locationDidChange
        )
    }
    
    func configureDisplayItem() {
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
    }
    
    /// An observer for ``TabContentContext``'s "`locationDidChange`" event. Delegates
    /// to ``updateItemVisibilities(forControl:)``.
    @objc func locationDidChange() {
        updateItemVisibilities(forControl: segmentedControl!)
    }
    
    /// Updates the segments in ``segmentedControl`` depending on the context's ability
    /// to navigate through web history.
    func updateItemVisibilities(forControl control: NSSegmentedControl) {
        // Maybe we should error here?
        guard sessionContext != nil,
              let currentContext = sessionContext!.currentTabContext
        else { return }
        
        let controlWidth = 28.0
        
        control.setEnabled(currentContext.canGoBack, forSegment: 0)
        control.setEnabled(currentContext.canGoForward, forSegment: 1)
    }
    
    
    /// The action handler for ``segmentedControl``'s back and forward buttons.
    @objc func backForwardClicked(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0:
            sessionContext?.currentTabContext?.goBack()
            break
        case 1:
            sessionContext?.currentTabContext?.goForward()
            break
        default: Logger.error("This should not happen.")
        }
        
        // FIXME: WKNavigationDelegate is not fulfilled.
        //updateItemVisibilities(forControl: sender)
    }
}
