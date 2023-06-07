//
//  BrowserSessionContext.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation

enum BrowsingMode {
    case publicBrowsing
    case privateBrowsing
}

class BrowserSessionContext: Equatable {
    
    let uuid = UUID()
    var mode: BrowsingMode
    var windowController: BrowserWindowController?
    var isMainContext: Bool {
        (Orion.shared as! Orion).mainBrowsingContext == self
    }
    
    init(mode: BrowsingMode) {
        self.mode = mode
    }
    
    static func == (lhs: BrowserSessionContext, rhs: BrowserSessionContext) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func createContent(andDisplay display: Bool = false) {
        if windowController == nil {
            windowController = BrowserWindowController(withContext: self)
        }
        
        windowController?.configureWindow()
        
        if display {
            windowController?.window?.makeKeyAndOrderFront(nil)
            navigateTo("https://kagi.com")
        }
    }
    
    // TODO: Multiple contexts corresponding to multiple windows.
    func becomeMainContext() {}
    
    func navigateTo(_ url: String) {
        windowController?.tabContentController.navigateTo(url)
    }
    
}
