//
//  TicTacToeUltimatumTests.swift
//  TicTacToeUltimatumTests
//
//  Created by Maksim Khrapov on 5/16/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

import XCTest
@testable import TicTacToeUltimatum

class TicTacToeUltimatumTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testCalcBestOpeningMove() {
        let boardState = BoardState()
        let aiEngine = MonteCarloTreeSearch(boardState)
        let result = aiEngine.basic(10000)
        print(result)
    }
    
    
    func testCalcOpeningMoveWithC() {
        let boardState = BoardState()
        let aiEngine = MonteCarloTreeSearch(boardState)
        let result = aiEngine.bridge_to_c(10000)
        print(result)
    }
}
