//
//  DebugApp.swift
//  Debug
//
//  Created by lcr on 2021/12/20.
//

import SwiftUI
import TopPageFeature

@main
struct WebAppSample: App {
    var body: some Scene {
        WindowGroup {
            TopPageView(url: "https://apple.com")
        }
    }
}
