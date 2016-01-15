//
//  TileValue.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/7/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

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
            return "−"
        case .multiply:
            return "×"
        default:
            return "\(self.rawValue)"
        }
    }
}

enum TileType: Int {
    case Number = 0
    case Operation = 1
}