//
//  PuzzleGeneratorTests.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import XCTest

class PuzzleGeneratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTileArrayContainsEnoughTileValues() {
        XCTAssert(PuzzleGenerator.sharedInstance.generateNewPuzzle().2.count == 9, "[TileArray] instance should have 9 TileArray objects")
    }
    
    func testSampleEquationSolutionMatchesFormat() {
        XCTAssert(NSPredicate(format: "SELF MATCHES %@", "[0-9] [-+x] [0-9] [-+x] [0-9] [-+x] [0-9] [-+x] [0-9] = [0-9]{1,5}").evaluateWithObject(PuzzleGenerator.sharedInstance.generateNewPuzzle().1), "Sample equation solution doesn't conform to required form")
    }
}
