//
//  WebViewKit.swift
//  
//
//  Created by lcr on 2021/12/20.
//

import SwiftUI
import WebKit

public struct WebViewError {
    let code: URLError.Code
    let message: String
}

public class WebViewStateModel: ObservableObject {
    @Published public var isLoading = false
    @Published public var canGoBack = false
    @Published public var shouldGoBack = false
    @Published public var shouldLoad = false
    @Published public var title = ""
    @Published var error: WebViewError?

    private(set) var url: String
    private let deepLinkIdentifier: String

    public init(url: String, deepLinkIdentifier: String) {
        self.url = url
        self.deepLinkIdentifier = deepLinkIdentifier
    }

    public func load(_ url: String) {
        self.url = url
        shouldLoad = true
    }

    public func onOpenUrl(_ url: String) {
        let openUrl = url.replacingOccurrences(of: deepLinkIdentifier, with:"")
        load(openUrl)
    }
}

public struct WebViewContainer: UIViewRepresentable {
    @ObservedObject var stateModel: WebViewStateModel

    public init(stateModel: WebViewStateModel) {
        self.stateModel = stateModel
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, stateModel: stateModel)
    }

    public func makeUIView(context: Context) -> WKWebView {

        guard let url = URL(string: stateModel.url) else {
            return WKWebView()
        }

        let webView = WKWebView()
        let request = URLRequest(url: url)

        webView.navigationDelegate = context.coordinator
        webView.load(request)

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if stateModel.shouldGoBack {
            uiView.goBack()
            stateModel.shouldGoBack = false
        }
        if stateModel.shouldLoad {
            guard let url = URL(string: stateModel.url) else {
                return
            }
            let request = URLRequest(url: url)
            uiView.load(request)
            stateModel.shouldLoad = false
        }
    }
}

public class Coordinator: NSObject, WKNavigationDelegate {
    @ObservedObject private var stateModel: WebViewStateModel
    private let parent: WebViewContainer

    init(parent: WebViewContainer, stateModel: WebViewStateModel) {
        self.parent = parent
        self.stateModel = stateModel
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        stateModel.isLoading = true
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stateModel.isLoading = false
        stateModel.title = webView.title ?? ""
        stateModel.canGoBack = webView.canGoBack
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stateModel.isLoading = false
        setError(error)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        stateModel.isLoading = false
        setError(error)
    }

    private func setError(_ error: Error) {
        if let error = error as? URLError {
            stateModel.error = WebViewError(code: error.code, message: error.localizedDescription)
        }
    }
}
