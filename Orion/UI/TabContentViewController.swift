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
    weak var browsingContext: BrowsingContext?
    /// Application content vendor (scripts/webpages, etc)
    var contentController = ContentController()
    
    init(withContext context: BrowsingContext?) {
        browsingContext = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Generates a configuration suitable for web context and initializes the WKWebView
    /// with it.
    func configureWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = ContentController()
    }
    
    /// Handles the configuration of the WKWebView and assigns delegation
    /// back to this controller
    func configureTabContentView() {
        
    }
    
}
