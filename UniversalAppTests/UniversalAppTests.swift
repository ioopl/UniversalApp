//
//  UniversalAppTests.swift
//  UniversalAppTests
//
//  Created by UHS on 22/02/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import XCTest
@testable import UniversalApp

class UniversalAppTests: XCTestCase {

    var timeout:TimeInterval = 30.00

    func testProductsAPIURL() {
        let URL = NSURL(string: "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20")!
        let expc = expectation(description: "Test Products Search API URL")
        let session = URLSession.shared
        let task = session.dataTask(with: URL as URL) { data, response, error in

            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")

            if let HTTPResponse = response as? HTTPURLResponse {
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            expc.fulfill()
        }
        task.resume()

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTFail("There is an Error")
            }
            task.cancel()
        }
    }
}
