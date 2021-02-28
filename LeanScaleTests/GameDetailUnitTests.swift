//
//  GameDetailUnitTests.swift
//  LeanScaleTests
//
//  Created by Mayank Gupta on 01/03/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import XCTest

class GameDetailUnitTests: XCTestCase {

    func test_GameDetailApiResource_With_ValidData_Returns_Response() {
        let gameDescViewModel = GameDescViewModel()
        let gameID = 3498
        let expectation = self.expectation(description: "ValidData_Returns_Response")
        
        gameDescViewModel.loadGameDesc(game: gameID) { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(gameID, data?.id)
            XCTAssertNotNil(data?.name)
            XCTAssertNotNil(data?.backgroundImage)
            XCTAssertNotNil(data?.description)
            XCTAssertEqual(data?.metacritic, 97)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_GameDetailApiResource_With_InValidData_Returns_Response() {
        let gameDescViewModel = GameDescViewModel()
        let gameID = 0203123123
        let expectation = self.expectation(description: "InValidData_Returns_Response")
        
        gameDescViewModel.loadGameDesc(game: gameID) { (data, error) in
            XCTAssertNil(data?.id)
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
