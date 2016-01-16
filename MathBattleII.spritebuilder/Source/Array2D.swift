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
    
    func enumerate() -> AnyGenerator<((Int, Int), T?)> {
        var index = 0
        var generator = array.generate()
        return anyGenerator() {
            if let item = generator.next() {
                let column = index % self.columns
                let row = index / self.columns
                ++index
                return ((column, row) , item)
            }
            return nil
        }
    }
}