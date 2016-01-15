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

enum TileValue: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case add = -1
    case subtract = -2
    case multiply = -3
}

extension TileValue {
    func checkIfNumberOrOperation() -> TileType {
        if self == TileValue.add || self == TileValue.subtract || self == TileValue.multiply {
            return TileType.Operation
        }
        else {
            return TileType.Number
        }
    }
    var stringValue: String {
        switch self {
        case .add:
            return "+"
        case .subtract:
            return "-"
        case .multiply:
            return "x"
        default:
            return "\(self.rawValue)"
        }
    }
}

enum TileType: Int {
    case Number = 0
    case Operation = 1
}