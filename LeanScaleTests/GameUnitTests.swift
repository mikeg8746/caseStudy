//
//  GameUnitTests.swift
//  LeanScaleTests
//
//  Created by Mayank Gupta on 01/03/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import XCTest

class GameUnitTests: XCTestCase {

    func test_GameApiResource_With_ValidData_Returns_Response() {
        let strUrl = Configuration.listingUrl()
        let expectation = self.expectation(description: "ValidData_Returns_Response")
        
        NetworkManager.getGameData(sourceURL: URL(string: strUrl)!) { (data, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            XCTAssertEqual(data?.count, 10)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_GameApiResource_With_SearchData_Returns_Response() {
        let searchString = "theft"
        let strUrl = Configuration.gameSearchUrl(search: searchString)
        let expectation = self.expectation(description: "SearchData_Returns_Response")
        
        NetworkManager.getGameData(sourceURL: URL(string: strUrl)!) { (data, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            
            let apiSearchedGames = data!.map{ $0.name }
            let filtered = apiSearchedGames.filter { $0!.localizedCaseInsensitiveContains(searchString) }
            XCTAssertEqual(filtered.count, apiSearchedGames.count)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
