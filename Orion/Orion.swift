//
//  Orion.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation
import AppKit

/// Main application class, and lifecycle entrypoint
@main
class Orion: NSApplication {
    /// Backing store for `mainBrowsingContext`
    private var _mainContext: BrowsingContext? = nil
    /// Simply the main browsing context. Setting this value triggers
    /// a lifecycle update on the new context.
    var mainBrowsingContext: BrowsingContext? {
        get { _mainContext }
        set {
            _mainContext = newValue
            _mainContext?.becomeMainContext()
        }
    }
    /// Instantiates a new `BrowsingContext`, configures, and displays it.
    func createContext(for browsingMode: BrowsingMode, displayWindow: Bool = false) -> BrowsingContext {
        let context = BrowsingContext(mode: browsingMode)
        context.createContent(andDisplay: displayWindow)
        return context
    }
    
    override func finishLaunching() {
        super.finishLaunching()
        let context = createContext(for: .publicBrowsing, displayWindow: true)
        mainBrowsingContext = context
    }
    
    /// The application entrypoint which is delegated to `NSApplicationMain` to initialize this class.
    static func main() {
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
    
}
