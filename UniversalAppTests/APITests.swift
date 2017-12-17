//
//  APITests.swift
//  UniversalApp
//
//  Created by UHS on 14/12/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import XCTest

class APITests: XCTestCase {
    
    var timeout:TimeInterval = 30.00
    override func setUp() {
        super.setUp()
    }
    
    /**
     Test Tracks API.
     */
    func testTracksAPIURL() {
        let URL = NSURL(string: "http://ws.audioscrobbler.com/2.0/?method=track.search&track=Just%20another%20Day&api_key=42b1c939f4743c1795620262dc138cd4&format=json")!
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
    
    /**
     Test Tracks Get Info API.
     */
    func testTracksAPIGetInfoURL() {
        let URL = NSURL(string: "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=42b1c939f4743c1795620262dc138cd4&artist=cher&track=believe&format=json&mbid=0d6a8ed1-febb-40aa-bb38-fff50b604b6e")!
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
