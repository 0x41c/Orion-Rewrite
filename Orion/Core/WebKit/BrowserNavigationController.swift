//
//  BrowserNavigationController.swift
//  Orion
//
//  Created by 0x41c on 2023-06-09.
//

import Foundation
import WebKit

/// Handles navigation delegation from the current tabs webview.
class BrowserNavigationController: Observable<BrowserNavigationController.NavigationEvent>,
                                   WKNavigationDelegate {
    /// The browsing session this navigation controller should operate under
    weak var browserSession: BrowserSession?
    private var tabDidChangeCertificate: BrowserSession.Certificate?
    /// The currently active webview. This variable changes depending on the value
    /// of the `currentTabSession`.
    var webView: WKWebView? {
        browserSession?.currentTabSession.webView
    }
    /// Whether the webview has the ability to go backwards in its history.
    var canGoBack: Bool {
        guard webView != nil else {
            return false
        }
        // swiftlint:disable:next force_unwrapping
        return webView!.backForwardList.backItem != nil
    }
    /// Whether the webview has the ability to go forwards in its history.
    var canGoForward: Bool {
        guard webView != nil else {
            return false
        }
        // swiftlint:disable:next force_unwrapping
        return webView!.backForwardList.forwardItem != nil
    }

    init(withSession session: BrowserSession?) {
        browserSession = session
        super.init()
        tabDidChangeCertificate = browserSession?.registerObserver(
            .currentTabDidChange,
            withTarget: self,
            selector: #selector(acceptCurrentTabIfNeeded)
        )
    }

    /// The registered observer of the `currentTabDidChange` event.
    @objc func acceptCurrentTabIfNeeded() {
        if webView?.navigationDelegate as? NSObject != self {
            webView?.navigationDelegate = self
        }
    }
    /// Sends `webView` to another location specified by `url`.
    func navigateTo(_ url: URL) {
        var request = URLRequest(url: url)
        // Basic upgrading, nice to have
        if url.scheme == "http" {
            request.httpMethod = "https"
        }
        locationChange {
            webView?.load(request)
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
            webView?.goForward()
        }
    }

    /// Navigates the webview backwards.
    func goBack() {
        if canGoBack {
            webView?.goBack()
        }
    }

    /// Tells the webview to reload.
    func reload() {
        webView?.reload()
    }

    // MARK: - Observable Navigation Events
    enum NavigationEvent {
        case locationWillChange
        case locationDidChange
    }

    /// Fires the `locationWillChange` and `locationDidChange` events in an event pair
    /// for a given block.
    private func locationChange(withBlock block: () -> Void) {
        fire(event: (.locationWillChange, .locationDidChange), wrapping: block)
    }

    // MARK: - WKNavigationDelegate
    // TODO: Extensions and Content script injection

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        decisionHandler(.allow)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        decisionHandler(.allow)
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        fire(event: .locationWillChange)
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        fire(event: .locationDidChange)
    }
}
