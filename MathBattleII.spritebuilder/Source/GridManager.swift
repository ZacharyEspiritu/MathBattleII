//
//  GridManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/8/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class GridManager {
    
    func checkIfRightAnswer(array: [TileValue]) -> Bool {
        if array.count == 9 {
            if array[0].checkIfNumberOrOperation() == TileType.Number &&
               array[1].checkIfNumberOrOperation() == TileType.Operation &&
               array[2].checkIfNumberOrOperation() == TileType.Number &&
               array[3].checkIfNumberOrOperation() == TileType.Operation &&
               array[4].checkIfNumberOrOperation() == TileType.Number &&
               array[5].checkIfNumberOrOperation() == TileType.Operation &&
               array[6].checkIfNumberOrOperation() == TileType.Number &&
               array[7].checkIfNumberOrOperation() == TileType.Operation &&
               array[8].checkIfNumberOrOperation() == TileType.Number {
                var possibleTargetValue = array[0].rawValue
                for index in 0..<4 {
                    if array[index] == TileValue.add {
                        possibleTargetValue += array[index + 1].rawValue
                    }
                }
            }
        }
        return false
    }
    
    func determineTappedTile(touch: CGPoint) {
        
    }
}