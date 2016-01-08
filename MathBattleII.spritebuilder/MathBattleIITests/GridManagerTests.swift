//
//  GridManagerTests.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/8/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import XCTest

class GridManagerTests: XCTestCase {
    
    private var gridInstance: GridManager!

    override func setUp() {
        super.setUp()
        gridInstance = GridManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGenerateNewPuzzle() {
        gridInstance.generateNewPuzzle()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
