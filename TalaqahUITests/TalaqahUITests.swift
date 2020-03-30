//
//  TalaqahUITests.swift
//  TalaqahUITests
//
//  Created by Horiah on 04/08/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import XCTest

class TalaqahUITests: XCTestCase {

    override func setUp() {
                continueAfterFailure = false

      
    }

    override func tearDown() {
       
    }

    func testExample() {
      
        let app = XCUIApplication()
        app.launch()
        

      
    }
   
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
