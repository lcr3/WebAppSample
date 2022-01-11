//
//  ScreenCoordinator.swift
//  
//
//  Created by lcr on 2022/01/08.
//

import Foundation

public struct ReceiveContent {
    public let url: String?

    public init(userInfo: [AnyHashable: Any]) {
        self.url = userInfo["url"] as? String
    }
}
