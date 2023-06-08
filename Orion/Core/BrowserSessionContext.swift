//
//  BrowserSessionContext.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation

/// A browser session, corresponding to one window and a collection of tabs.
class BrowserSessionContext: Equatable {
    /// A unique ID for this session.
    var sessionUUID = UUID()
    /// The window controller for this session.
    var sessionController: BrowserWindowController?
    /// The content controller for this session
    var sessionContentController: TabContentViewController?
    /// The window toolbar controller for the session
    var sessionToolbarController: ToolbarController?
    /// A collection of tab contexts, each corresponding to a tab.
    var tabContexts: [TabContentContext] = []
    /// Reference to the current tab context. Tab-specific operations are handled through here.
    var currentTabContext: TabContentContext?
    
    init() {}
    
    /// Configures the components of the session, namely the `sessionController`, `sessionToolbarController`
    /// and `sessionContentController` objects.
    func configureSession() {
        sessionController = BrowserWindowController(withContext: self)
        sessionToolbarController = ToolbarController(withContext: self)
        sessionContentController = TabContentViewController(withContext: self)
        sessionController!.configureWindow()
        sessionToolbarController!.configureToolbar(inWindow: sessionController!.window)
        
        // Imagine putting people on anything other than kagi.com... imagine being the guy who did that.
        createNewTab(withStartLocation: "https://kagi.com")
        
        sessionController!.window?.contentViewController = sessionContentController
    }
    
    /// Creates a new tab and associated tab context.
    func createNewTab(withStartLocation startLoc: String) {
        let newTab = TabContentContext(withContext: self)
        newTab.navigateTo(startLoc)
        tabContexts.append(newTab)
        currentTabContext = newTab
    }
    
    /// Simply gives this session focus and directs the user to it.
    func becomeMainSession() {
        sessionController?.window?.makeKeyAndOrderFront(nil)
    }
    
    // FIXME: Wouldn't hurt to establish a good tear-down cycle.
    func tearDownSession() {}
    
    // MARK: - Equatable

    static func == (lhs: BrowserSessionContext, rhs: BrowserSessionContext) -> Bool {
        lhs.sessionUUID == rhs.sessionUUID
    }
    
}
