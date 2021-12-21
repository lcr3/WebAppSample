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
        webStateModel = WebViewStateModel(url: "")
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
}
