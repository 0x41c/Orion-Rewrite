//
//  TabContentContext.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import WebKit

// FIXME: Webkit's delegation should go elsewhere/should be implemented.

/// Context provided to the `TabContentViewController` containing a webview
/// and other needed metadata.
class TabContentContext: NSObject, WKNavigationDelegate, WKUIDelegate {
    /// The parent session of this tab.
    weak var sessionContext: BrowserSessionContext?
    /// Backing storage for `webView`
    private var _webView: WKWebView?
    
    /// The webview associated with this context.
    var webView: WKWebView {
        if _webView == nil {
            let configuration = WKWebViewConfiguration()
            configuration.applicationNameForUserAgent = "Orion Browser"
            configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
            
            _webView = WKWebView(frame: .zero, configuration: configuration)
            _webView?.navigationDelegate = self
            _webView?.uiDelegate = self
        }
        
        return _webView!
    }
    
    init(withContext context: BrowserSessionContext?) {
        sessionContext = context
    }
    
    /// Sends `webView` to another location specified by `url`.
    func navigateTo(_ url: URL) {
        var request = URLRequest(url: url)
        // Basic upgrading, nice to have
        if url.scheme == "http" {
            request.httpMethod = "https"
        }
        webView.load(request)
    }
    
    /// Sends `webView` to another location specified by `url`.
    /// - note: Requires `url` to be valid.
    func navigateTo(_ url: String) {
        guard let parsedURL = URL(string: url) else { return }
        navigateTo(parsedURL)
    }
    
    /// Navigates the webview forwards
    func goForward() {
        webView.goForward()
    }
    
    /// Navigates the webview backwards
    func goBack() {
        webView.goBack()
    }
    
}
