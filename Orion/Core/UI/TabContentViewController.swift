//
//  TabContentViewController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-06.
//

import Foundation
import AppKit
import WebKit

/// Implements the browsing interface. The only content permitted in this project scope
/// is web-content; Therefore, that's the only content that will be vended by this class.
class TabContentViewController: NSViewController {
    /// Reference to browsing context to provide information about current tab state
    weak var sessionContext: BrowserSessionContext?
    
    init(withContext context: BrowserSessionContext?) {
        sessionContext = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called when the window controller assigns this controller as the `contentViewController`.
    override func loadView() {
        currentTabChanged()
    }
    
    /// (Re)Assigns the view to the current context's webview.
    func currentTabChanged() {
        view = sessionContext!.currentTabContext!.webView
        view.frame = NSRect(
            origin: .zero,
            size: sessionContext!.sessionController!.window!.frame.size
        )
    }
    
}
