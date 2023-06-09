//
//  TabContentContext.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import WebKit

// FIXME: Webkit's delegation should go elsewhere/should be implemented. Consideration should
// also be made in the making of TabContentContext a subclass of WKWebView.

/// Context provided to the ``TabContentViewController`` containing a webview
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
    /// Whether the webview has the ability to go backwards in its history.
    var canGoBack: Bool { webView.canGoBack }
    /// Whether the webview has the ability to go forwards in its history.
    var canGoForward: Bool { webView.canGoForward }
    /// A list of observers for certain web events described in ``ContextEvent``
    private var contextObservers: [ContextObserverMetadata] = []
    
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
        locationChange {
            webView.load(request)
        }
    }
    
    /// Sends ``webView`` to another location specified by `url`.
    /// - note: Requires `url` to be valid.
    func navigateTo(_ url: String) {
        guard let parsedURL = URL(string: url) else { return }
        navigateTo(parsedURL)
    }
    
    /// Navigates the webview forwards.
    func goForward() {
        if canGoForward {
            locationChange {
                webView.goForward()
            }
        }
    }
    
    /// Navigates the webview backwards.
    func goBack() {
        if canGoBack {
            locationChange {
                webView.goBack()
            }
        }
    }
    
    /// Tells the webview to reload.
    func reload() {
        webView.reload()
    }
    
}

// MARK: - Context Events
// TODO: Isolate event base and move to BrowserSessionContext

extension TabContentContext {
    /// Metadata associated with an observer.
    typealias ContextObserverMetadata = (
        target: NSObject,
        selector: Selector,
        event: ContextEvent
    )
    
    /// The different events that a ``TabContentContext`` triggers.
    enum ContextEvent {
        /// Triggered when the context's webview is about to navigate to a different location.
        case locationWillChange
        /// Triggered after the context's webview has changed locations.
        case locationDidChange
    }
    
    /// Adds a context observer that will fire when the specified event is triggered
    /// due to a contextual state change inside of the ``TabContentContext``.
    func registerContextObserver(withObservationMetadata metadata: ContextObserverMetadata) {
        guard !contextObservers.contains(where: { other in
            other.target == metadata.target
            && other.selector == metadata.selector
            && other.event == metadata.event
        }) else {
            Logger.error("Attempted to register duplicate observer: \(metadata)")
        }
        
        guard metadata.target.responds(to: metadata.selector) else {
            Logger.error("Cannot register observer with mismatched target/selector pair.")
        }
        
        contextObservers.append(metadata)
    }
    
    /// Registers a context observer that will fire when the specified event is triggered
    /// due to a contextual state change inside of the ``TabContentContext``.
    func registerContextObserver(target: NSObject, selector: Selector, event: ContextEvent) {
        registerContextObserver(withObservationMetadata: (target, selector, event))
    }
    
    /// Fires the provided event, triggering any observers registered with
    /// ``registerContextObserver(withObservationMetadata:)`` or ``registerContextObserver(target:selector:event:)``
    private func fireEvent(_ event: ContextEvent) {
        contextObservers.filter { $0.event == event }.forEach {
            $0.target.perform($0.selector)
        }
    }
    
    /// Fires the ``locationWillChange`` and ``locationDidChange`` events
    /// surrounding a block expected to change the location of the context's ``webView``.
    private func locationChange(withBlock changingBlock: () -> Void) {
        fireEvent(.locationWillChange)
        changingBlock()
        fireEvent(.locationDidChange)
    }
}
