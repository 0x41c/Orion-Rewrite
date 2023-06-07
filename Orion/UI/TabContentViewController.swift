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
class TabContentViewController: NSViewController, WKNavigationDelegate, WKUIDelegate {
    /// Reference to browsing context to provide information about current tab state
    weak var browsingContext: BrowserSessionContext?
    /// Application content vendor (scripts/webpages, etc)
    var contentController = ContentController()
    /// The managed webview; The only content as mentioned in the class documentation
    var webView: WKWebView?
    
    init(withContext context: BrowserSessionContext?) {
        browsingContext = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called when the window controller assigns this controller as the `contentViewController`.
    /// - note: This is done so the view has direct access to the window for `configureTabContentView`
    override func loadView() {
        configureWebView()
    }
    
    /// Generates a configuration suitable for Orions web context and initializes `webView`
    /// with it. Assigns the delegation back to this controller.
    func configureWebView() {
        guard webView == nil else { return }
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Orion Browser"
        configuration.userContentController = contentController
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        view = webView!
    }
    
    /// Sends `webView` to another location specified by `url`.
    func navigateTo(_ url: URL) {
        var request = URLRequest(url: url)
        // Basic upgrading, nice to have
        if url.scheme == "http" {
            request.httpMethod = "https"
        }
        webView?.load(request)
    }
    
    /// Sends `webView` to another location specified by `url`.
    /// - note: Requires `url` to be valid.
    func navigateTo(_ url: String) {
        guard let parsedURL = URL(string: url) else { return }
        navigateTo(parsedURL)
    }
    
    // TODO: Save navigations
    /// Simple redirection to `WKWebView.goBack()`
    func goBack() { webView?.goBack() }
    /// Simple redirection to `WKWebView.goForward()`
    func goForward() { webView?.goForward() }
    
}
