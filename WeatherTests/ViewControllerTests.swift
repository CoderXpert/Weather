//
//  ViewControllerTests.swift
//  Weather
//
//  Created by Adnan Aftab on 3/9/16.
//  Copyright © 2016 CX. All rights reserved.
//

import XCTest

@testable import Weather

class ViewControllerTests: XCTestCase {
    
    var viewController : ViewController?
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
        viewController?.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testViewDidLoadMethod(){
        class MockViewController : ViewController {
            var called = false
            override func registerForViewModelNotificaitons() {
                called = true
            }
        }
        let mock = MockViewController()
        XCTAssertFalse(mock.called, "at start it should be false")
        mock.viewDidLoad()
        XCTAssertTrue(mock.called, "register notification method was not called")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
