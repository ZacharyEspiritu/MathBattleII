//
//  TileValue.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/7/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

enum TileValue: Int {
    case Zero = 0
    case One = 1
    case Two = 2
    case Three = 3
    case Four = 4
    case Five = 5
    case Six = 6
    case Seven = 7
    case Eight = 8
    case Nine = 9
    
    case Add = -1
    case Subtract = -2
    case Multiply = -3
}

extension TileValue {
    
    /**
     Checks if the `TileValue` is of `TileType.Operation` or `TileType.Number`.
     - returns:   the corresponding `TileType` of the `TileValue`
     */
    func checkIfNumberOrOperation() -> TileType {
        if self == TileValue.Add || self == TileValue.Subtract || self == TileValue.Multiply {
            return TileType.Operation
        }
        else {
            return TileType.Number
        }
    }
    
    /**
     Converts the `TileValue` to a corresponding `stringValue`.
     */
    var stringValue: String {
        switch self {
        case .Add:
            return "+"
        case .Subtract:
            return "−"
        case .Multiply:
            return "×"
        default:
            if self.rawValue >= 0 {
                return "\(self.rawValue)"
            }
            else {
                assertionFailure()
                return ""
            }
        }
    }
}