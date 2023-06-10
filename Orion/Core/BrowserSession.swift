//
//  BrowserSession.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation

private let kagiOP = "https://kagi.com"

/// A browser session, corresponding to a window and a collection of tabs.
class BrowserSession: Observable<BrowserSession.SessionEvent> {
    var sessionController: BrowserWindowController?
    var sessionNavigationController: BrowserNavigationController?
    var sessionContentController: TabContentViewController?
    var sessionToolbarController: ToolbarController?
    var tabSessions: [TabSession] = []
    private var _currentTabSession: TabSession?
    var currentTabSession: TabSession {
        get {
            guard _currentTabSession != nil else {
                Logger.error("Current tab was nil. This should not happen.")
            }
            // swiftlint:disable:next force_unwrapping
            return _currentTabSession!
        }
        set {
            fire(event: (.currentTabWillChange, .currentTabDidChange)) {
                _currentTabSession = newValue
                let hasNewValue = tabSessions.contains(newValue)
                if hasNewValue {
                    if newValue != tabSessions.last {
                        // swiftlint:disable:next force_unwrapping
                        tabSessions.remove(at: tabSessions.firstIndex(of: newValue)!)
                    }
                } else {
                    tabSessions.append(newValue)
                }
            }
        }
    }

    /// Configures the key components of a browser session.
    func configureSession() {
        sessionController = BrowserWindowController(withSession: self)
        sessionNavigationController = BrowserNavigationController(withSession: self)
        sessionContentController = TabContentViewController(withSession: self)
        sessionToolbarController = ToolbarController(withSession: self)

        // Imagine putting people on anything other than kagi.com. It would suck to
        // be the guy who did that... yeah...
        openTab()

        // swiftlint:disable:next force_unwrapping
        sessionController!.window?.contentViewController = sessionContentController
    }

    /// Gives this session focus and directs the user to it.
    func becomeMainSession() {
        sessionController?.window?.makeKeyAndOrderFront(nil)
        fire(event: .didBecomeMain)
    }

    // FIXME: Wouldn't hurt to establish a good tear-down cycle.
    func tearDownSession() {
        fire(event: .didResignMain)
    }

    /// Creates a new tab and associated tab context.
    func openTab(withStartLocation startLoc: String = kagiOP) {
        let newTab = TabSession(withBrowserSession: self)
        currentTabSession = newTab
        sessionNavigationController?.navigateTo(startLoc)
        fire(event: .tabOpened)

    }

    /// Closes the current tab. Temporarily, this function will create
    /// a new tab if there is no fallback tab.
    func closeTab() {
        let oldTab = currentTabSession
        guard let oldTabIndex = tabSessions.firstIndex(of: oldTab) else {
            Logger.error("Old tab was never added to tabSessions.")
        }
        
        tabSessions.remove(at: oldTabIndex)
        if tabSessions.count == 0 { openTab() }

        fire(event: .tabClosed)
        
        guard let focusedTab = tabSessions.last else {
            Logger.error("Unable to close further.")
        }

        currentTabSession = focusedTab
    }

    /// The event types a ``BrowserSession`` will emit.
    enum SessionEvent {
        /// Emitted when the current tab is about to be reassigned.
        case currentTabWillChange
        /// Emitted when the current tab has been reassigned to a different tab.
        case currentTabDidChange
        /// Emitted when a new tab is opened
        case tabOpened
        /// Emitted when an existing tab is closed
        case tabClosed
        /// Emitted when status as the main browser session has been passed to a
        /// different session
        case didResignMain
        /// Emitted when status as teh main browser session has been gained
        case didBecomeMain
    }
}
