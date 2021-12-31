//
//  TopPageFeature.swift
//  
//
//  Created by lcr on 2021/12/20.
//

import SwiftUI
import WebView

public struct TopPageView: View {
  @StateObject var webViewStore = WebViewStore()
    public init() {
    }

  public var body: some View {
    NavigationView {
      WebView(webView: webViewStore.webView)
        .navigationBarTitle(Text(verbatim: webViewStore.title ?? ""), displayMode: .inline)
        .navigationBarItems(trailing: HStack {
          Button(action: goBack) {
            Image(systemName: "chevron.left")
              .imageScale(.large)
              .aspectRatio(contentMode: .fit)
              .frame(width: 32, height: 32)
          }.disabled(!webViewStore.canGoBack)
          Button(action: goForward) {
            Image(systemName: "chevron.right")
              .imageScale(.large)
              .aspectRatio(contentMode: .fit)
              .frame(width: 32, height: 32)
          }.disabled(!webViewStore.canGoForward)
        })
    }.onAppear {
      self.webViewStore.webView.load(URLRequest(url: URL(string: "https://apple.com")!))
    }
  }

  func goBack() {
    webViewStore.webView.goBack()
  }

  func goForward() {
    webViewStore.webView.goForward()
  }
}
