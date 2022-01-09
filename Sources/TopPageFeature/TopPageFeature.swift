//
//  TopPageFeature.swift
//  
//
//  Created by lcr on 2021/12/20.
//

import SwiftUI
import WebViewKit

public struct TopPageView: View {
    @ObservedObject var stateModel: WebViewStateModel

    public init(defaultUrl: String, deepLinkIdentifier: String) {
        self.stateModel = WebViewStateModel(
            url: defaultUrl,
            deepLinkIdentifier: deepLinkIdentifier
        )
    }

    public var body: some View {
        NavigationView {
            ZStack {
                WebViewContainer(stateModel: stateModel)
                if stateModel.isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle(Text(stateModel.title), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    stateModel.shouldGoBack = true
                }) {
                    if stateModel.canGoBack {
                        Text("<Back")
                    } else {
                        EmptyView()
                    }
                },
                trailing: Button(action: {
                    stateModel.load("https://google.com")
                }) {
                    Text("Google")
                }
            )
            .onOpenURL { url in
                stateModel.onOpenUrl(url.absoluteString)
            }
        }
    }
}
