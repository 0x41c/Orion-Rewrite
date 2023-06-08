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
    /// A collection of sessions, each with their own window and tabs.
    var sessions: [BrowserSessionContext] = []
    /// Backing store for `mainSession`
    private var _mainSession: BrowserSessionContext = BrowserSessionContext()
    /// Simply the main browsing context. Setting this value triggers
    /// a lifecycle update on the new context.
    var mainSession: BrowserSessionContext {
        get { _mainSession }
        set {
            if !sessions.contains(newValue) {
                sessions.append(newValue)
            }
            _mainSession = newValue
            _mainSession.becomeMainSession()
        }
    }

    /// Opens a new session and optionally preserves the current main session state.
    func open(sessionInBackground: Bool = false) {
        let session = BrowserSessionContext()
        sessions.append(session)
        session.configureSession()
        guard !sessionInBackground else { return }
        mainSession = session
    }
    
    /// Closes a session. If the provided `session` is contained in `sessions`, it will be
    /// removed. When no sessions exist, a new one will be created.
    func close(session: BrowserSessionContext) {
        guard let sessionIndex = sessions.firstIndex(of: session) else {
            Logger.warn("Attempting to close an ambiguous session")
            return
        }
        
        sessions.remove(at: sessionIndex)
        
        if session == mainSession {
            if sessions.isEmpty {
                open()
            } else {
                mainSession = sessions.last!
            }
        }
        
        session.tearDownSession()
    }
    
    override func finishLaunching() {
        super.finishLaunching()
        open()
    }
    
    /// The application entrypoint which is delegated to `NSApplicationMain` to initialize this class.
    static func main() {
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
    
}
