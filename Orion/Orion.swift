//
//  Orion.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation
import AppKit

@main
class Orion: NSApplication {
    
    private var _mainContext: BrowsingContext? = nil
    
    var browsingContexts: [BrowsingContext]
    var mainBrowsingContext: BrowsingContext? {
        get { _mainContext }
        set {
            if newValue != nil && !browsingContexts.contains(newValue!) {
                browsingContexts.append(newValue!)
            }
            _mainContext = newValue
            _mainContext?.becomeMainContext()
        }
    }
    
    override init() {
        browsingContexts = [BrowsingContext]()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createContext(for browsingMode: BrowsingMode, displayWindow: Bool = false) {
        let context = BrowsingContext(mode: browsingMode)
        context.createContent(andDisplay: displayWindow)
    }
    
    override func finishLaunching() {
        super.finishLaunching()
        createContext(for: .publicBrowsing, displayWindow: true)
    }
    
    static func main() {
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
    
}
