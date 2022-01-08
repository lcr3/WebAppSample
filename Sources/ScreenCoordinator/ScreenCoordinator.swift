//
//  ScreenCoordinator.swift
//  
//
//  Created by lcr on 2022/01/08.
//

import Foundation

public final class ScreenCoordinator: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var selectedDetailId = Selection<String>(isSelected: false, item: nil)
    @Published var selectedPopupId = Selection<String>(isSelected: false, item: nil)
    public init() {}
}

public struct Selection<T> {
  var isSelected = false
  var item: T?
}

public struct ReceiveContent {
    let url: String?

    public init(userInfo: [AnyHashable: Any]) {
        self.url = userInfo["url"] as? String
    }
}
