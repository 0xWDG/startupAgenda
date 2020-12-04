//
//  StartUpAgendaControllerTests.swift
//  StartUpAgendaInterface
//
//  Created by Mark Cornelisse on 13/07/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import UIKit
import StartUpAgendaInterface
import XCTest

class StartUpAgendaControllerTests: XCTestCase {
    let agendaController = StartUpAgendaController.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testfetchMeetings() {
        // This is an example of a functional test case.
        let expectation = expectationWithDescription("updateMeetings")
        
        agendaController.fetchMeetings { (error) -> () in
            XCTAssertNil(error, "There should be no error returning.")
            XCTAssertTrue(self.agendaController.meetings.count > 0, "There should be meetings fetched.")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(600, handler: { (error) -> Void in
            XCTAssertNil(error, "Timeout Error: \(error)")
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
