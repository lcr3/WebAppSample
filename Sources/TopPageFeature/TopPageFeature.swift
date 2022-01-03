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

    public init(defaultUrl: String) {
        self.stateModel = WebViewStateModel(url: defaultUrl)
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
        }
    }
}
