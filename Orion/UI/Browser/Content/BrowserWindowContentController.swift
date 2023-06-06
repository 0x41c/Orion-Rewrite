//
//  WindowContentController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-05.
//

import Foundation
import AppKit

class BrowserWindowContentController: NSViewController {
    
    var contentMode: ContentMode
    
    init(contentMode mode: ContentMode) {
        contentMode = mode
        super.init(nibName: nil, bundle: nil)
        view = NSView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BrowserWindowContentController {
    
    enum ContentType {
        case native
        case webview
    }
    
    enum ContentMode {
        case startpage
        case webpage
        // TODO: Special page for reviewers?
        
        var contentType: ContentType {
            switch self {
            case .startpage:
                return .native
            case .webpage:
                return .webview
            }
        }
    }
    
}
