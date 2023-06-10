//
//  TabContentContext.swift
//  Orion
//
//  Created by 0x41c on 2023-06-07.
//

import Foundation
import WebKit

/// A session provided to the ``TabContentViewController`` containing a webview
/// and other needed metadata.
class TabSession: NSObject {
    /// The parent session of this tab.
    weak var browserSession: BrowserSession?
    /// Backing storage for `webView`
    private var _webView: WKWebView?
    /// The webview associated with this tab.
    var webView: WKWebView {
        if _webView == nil {
            let configuration = WKWebViewConfiguration()
            configuration.applicationNameForUserAgent = "Orion Browser"
            configuration.preferences.javaScriptCanOpenWindowsAutomatically = false

            _webView = WKWebView(frame: .zero, configuration: configuration)
        }

        // swiftlint:disable:next force_unwrapping
        return _webView!
    }

    init(withBrowserSession session: BrowserSession?) {
        browserSession = session
    }
}
