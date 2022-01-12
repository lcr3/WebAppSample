//
//  WebViewStateModelTests.swift
//  
//
//  Created by lcr on 2021/12/21.
//

import WebViewKit
import XCTest

class WebViewStateModelTests: XCTestCase {
    var webStateModel: WebViewStateModel!

    override func setUpWithError() throws {
        super.setUp()
        webStateModel = WebViewStateModel(
            url: "https://www.google.co.jp/",
            deepLinkIdentifier: "lcrdev://"
        )
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testInitModel() throws {
        // setup
        XCTAssertEqual(webStateModel.shouldLoad, false)

        // execute
        webStateModel.load("https://google.com")

        // verify
        XCTAssertEqual(webStateModel.shouldLoad, true)
    }

    func testOnOpvenUrl() {
        // setup
        XCTAssertEqual(webStateModel.shouldLoad, false)

        // execute
        webStateModel.onOpenUrl("lcrdev://https://www.youtube.com/")

        // verify
        XCTAssertEqual(webStateModel.shouldLoad, true)
    }
}
