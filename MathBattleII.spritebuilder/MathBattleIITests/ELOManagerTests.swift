//
//  ELOManagerTests.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import XCTest

class ELOManagerTests: XCTestCase {
    
    let manager = ELOManager()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUpdateRatingsWithLowWinner() {
        let winnerRating: Int = 1250
        let loserRating: Int = 1274
        let expected: (Int, Int) = (1267, 1256)
        let updatedRatings: (Int, Int) = manager.updateRatings(winner: winnerRating, loser: loserRating)
        XCTAssertEqual(updatedRatings.0, expected.0, "newWinnerRating should be equal to \(expected.0) but came out \(updatedRatings.0).")
        XCTAssertEqual(updatedRatings.1, expected.1, "newLoserRating should be equal to \(expected.1) but came out \(updatedRatings.0).")
    }
    
    func testUpdateRatingsWithHighWinner() {
        let winnerRating: Int = 1274
        let loserRating: Int = 1250
        let expected: (Int, Int) = (1288, 1235)
        let updatedRatings: (Int, Int) = manager.updateRatings(winner: winnerRating, loser: loserRating)
        XCTAssertEqual(updatedRatings.0, expected.0, "newWinnerRating should be equal to \(expected.0) but came out \(updatedRatings.0).")
        XCTAssertEqual(updatedRatings.1, expected.1, "newLoserRating should be equal to \(expected.1) but came out \(updatedRatings.0).")
    }
    
    func testUpdateRatingsWithMinimumRating() {
        let winnerRating: Int = 705
        let loserRating: Int = 701
        let expected: (Int, Int) = (720, 700)
        let updatedRatings: (Int, Int) = manager.updateRatings(winner: winnerRating, loser: loserRating)
        XCTAssertEqual(updatedRatings.0, expected.0, "newWinnerRating should be equal to \(expected.0) but came out \(updatedRatings.0).")
        XCTAssertEqual(updatedRatings.1, expected.1, "newLoserRating should be equal to \(expected.1) but came out \(updatedRatings.0).")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
