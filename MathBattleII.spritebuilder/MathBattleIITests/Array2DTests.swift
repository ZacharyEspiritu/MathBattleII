//
//  Array2DTests.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/22/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import XCTest

class Array2DTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArraySizeInitalization() {
        let numberOfColumns = 10
        let numberOfRows = 15
        let array: Array2D = Array2D<AnyObject>(columns: numberOfColumns, rows: numberOfRows)
        XCTAssertEqual(array.columns, 10, "The number of columns in the Array2D should be \(numberOfColumns) but came out \(array.columns)")
        XCTAssertEqual(array.rows, 15, "The number of columns in the Array2D should be \(numberOfRows) but came out \(array.rows)")
    }
}