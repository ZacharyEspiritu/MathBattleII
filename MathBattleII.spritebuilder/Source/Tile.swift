//
//  Tile.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/7/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Tile: CCSprite9Slice {
    
    private weak var label: CCLabelTTF!
    private var value: TileValue? {
        didSet {
            label.string = "\(value!.rawValue)"
        }
    }
    private var type: TileType?
    
    func setTileValue(value: TileValue) {
        self.value = value
        type = value.checkIfNumberOrOperation()
    }
    
    func getTileValue() -> TileValue? {
        return value
    }
    
    func getTypeType() -> TileType? {
        return type
    }
}