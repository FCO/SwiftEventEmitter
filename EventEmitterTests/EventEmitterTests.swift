//
//  EventEmitterTests.swift
//  EventEmitterTests
//
//  Created by Fernando Oliveira on 12/10/15.
//  Copyright © 2015 FCO. All rights reserved.
//

import XCTest
@testable import EventEmitter

class EventEmitterTests: XCTestCase {
    let eventEmitter = EventEmitter()
    var shouldExists : Bool = true
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = expectationWithDescription("Events")
        eventEmitter.on("event1") {
            (data : Bool) in
            XCTAssertTrue(data)
            self.eventEmitter.emit("event1", data: 42)
        }
        eventEmitter.on("event1") {
            (data : Int) in
            XCTAssertEqual(data, 42)
            self.eventEmitter.emit("event1", data: "bla")
        }
        eventEmitter.once("event1") {
            (data : String) in
            if self.shouldExists {
                XCTAssertEqual(data, "bla")
                expectation.fulfill()
                self.eventEmitter.emit("event1", data: "ble ")
                self.shouldExists = false
            } else {
                XCTFail("Once should run only once")
            }
        }
        eventEmitter.emit("event1", data: true)

        waitForExpectationsWithTimeout(10) {error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
