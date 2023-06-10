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
    /// Reference to the current browser session for accessing tab sessions.
    weak var browserSession: BrowserSession?
    /// An certificate for a ``browserSession``'s `currentTabDidChange` event observer.
    var tabWillChangeCertificate: BrowserSession.Certificate?
    /// Reference to the current tab session.
    var currentTabSession: TabSession? {
        browserSession?.currentTabSession
    }
    /// A content container allowing transitions between webviews to be adaptive.
    var tabContainerView = NSView()

    init(withSession session: BrowserSession?) {
        browserSession = session
        super.init(nibName: nil, bundle: nil)
        tabWillChangeCertificate = browserSession?.registerObserver(
            .currentTabDidChange,
            withTarget: self,
            selector: #selector(updateViewForCurrentTab)
        )
    }

    required init(coder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Called when the window controller assigns this controller as the `contentViewController`.
    override func loadView() {
        updateViewForCurrentTab()
    }

    /// Assigns the managed `view` to the current tabs web view.
    @objc func updateViewForCurrentTab() {
        guard let webView = currentTabSession?.webView,
              let window = browserSession?.sessionController?.window else {
            Logger.error("Attempted to setup tab container without a webview/window.")
        }

        webView.translatesAutoresizingMaskIntoConstraints = false

        if tabContainerView.subviews.isEmpty {
            let size = window.frame.size
            view = tabContainerView
            view.translatesAutoresizingMaskIntoConstraints = false
            tabContainerView.setFrameSize(size)
        }

        tabContainerView.subviews.first?.removeFromSuperview()
        tabContainerView.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalTo: tabContainerView.widthAnchor),
            webView.heightAnchor.constraint(equalTo: tabContainerView.heightAnchor)
        ])
    }
}
