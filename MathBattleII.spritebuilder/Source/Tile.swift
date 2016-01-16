//
//  Tile.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Tile: CCNode {
    
    weak var sprite: CCSprite!
    weak var label: CCLabelTTF!
    private var value: TileValue! {
        didSet {
            label.string = "\(value!.stringValue)"
        }
    }
    private var type: TileType!
    
    private var selected: Bool = false
    
    func setTileValue(value: TileValue) {
        self.value = value
        type = value.checkIfNumberOrOperation()
    }
    
    func getTileValue() -> TileValue {
        return value
    }
    
    func getTypeType() -> TileType {
        return type
    }
    
    func isSelected() -> Bool {
        return selected
    }
    
    func selectTile() {
        selected = true
        sprite.color = CCColor(white: 0.5, alpha: 1)
    }
    
    func deselectTile() {
        selected = false
        sprite.color = CCColor(white: 1, alpha: 1)
    }
    
}