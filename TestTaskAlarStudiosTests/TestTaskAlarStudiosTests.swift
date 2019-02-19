//
//  TestTaskAlarStudiosTests.swift
//  TestTaskAlarStudiosTests
//
//  Created by Oleg Soloviev on 19.02.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import XCTest
@testable import TestTaskAlarStudios

class TestTaskAlarStudiosTests: XCTestCase {
    var sessionUnderTest: URLSession!
    let url = URL(string: "https://alarstudios.com/test/data.cgi?p=1&code=0555433145")

    override func setUp() {
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
    }
    
    func testValidCallGetsHTTPStatusCode200() {
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCallCompletes() {
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
