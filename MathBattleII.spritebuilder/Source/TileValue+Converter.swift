//
//  TileValue+Converter.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

extension TileValue {
    /**
     Checks if the `TileValue` is of `TileType.Operation` or `TileType.Number`.
     - returns:   the corresponding `TileType` of the `TileValue`
     */
    func checkIfNumberOrOperation() -> TileType {
        if self == TileValue.add || self == TileValue.subtract || self == TileValue.multiply {
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