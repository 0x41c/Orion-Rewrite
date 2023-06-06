//
//  BrowsingContext.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation

enum BrowsingMode {
    case publicBrowsing
    case privateBrowsing
}

class BrowsingContext: Equatable {
    
    let uuid = UUID()
    var mode: BrowsingMode
    var browsingWindowController: BrowserWindowController?
    var isMainContext: Bool {
        (Orion.shared as! Orion).mainBrowsingContext == self
    }
    
    init(mode: BrowsingMode) {
        self.mode = mode
    }
    
    static func == (lhs: BrowsingContext, rhs: BrowsingContext) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func createContent(andDisplay display: Bool = false) {
        if browsingWindowController == nil {
            browsingWindowController = BrowserWindowController(browsingContext: self)
        }
        
        browsingWindowController?.configureContent()
        
        if display {
            browsingWindowController?.window?.makeKeyAndOrderFront(nil)
        }
    }
    
    func becomeMainContext() {
        print("[BrowsingContext: \(uuid)] Making main")
    }
    
}
