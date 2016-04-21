//
//  Array2D.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

struct Array2D<T> {
    
    let columns: Int
    let rows: Int
    
    private var array: Array<T?>
    
    /**
     Creates a new `Array2D` objects with capacity `columns` x `rows`.
     - parameter columns:   the number of columns in the Array2D
     - parameter rows:      the number of columns in the Array2D
     */
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows*columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
    
    /**
     Converts the `Array2D` object into a one-dimensional, sequential `Generator`. 
     Mainly intended for using `Array2D` instances in for-in loops.
     - returns:   a one-dimensional `Generator` that can return a "next element" in the generated sequence
     */
    func enumerate() -> AnyGenerator<((Int, Int), T?)> {
        var index = 0
        var generator = array.generate()
        return AnyGenerator() {
            if let item = generator.next() {
                let column = index % self.columns
                let row = index / self.columns
                index += 1
                return ((column, row) , item)
            }
            return nil
        }
    }
}