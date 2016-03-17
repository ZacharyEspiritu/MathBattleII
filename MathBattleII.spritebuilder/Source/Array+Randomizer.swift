//
//  Array+Randomizer.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/16/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

extension Array {
    /**
     Randomizes the order of the elements in the array. Mutates the array itself.
     */
    mutating func randomizeOrder() {
        var oldArray: [Element] = self
        var newArray: [Element] = []
        while oldArray.count > 0 {
            let index: Int = Int(arc4random_uniform(UInt32(oldArray.count)))
            newArray.append(oldArray[index])
            oldArray.removeAtIndex(index)
        }
        self = newArray
    }
}