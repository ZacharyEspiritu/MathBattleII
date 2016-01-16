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
    
    /**
     Sets the `TileValue` of the `Tile` to the supplied `value`.
     Also updates the `TileType` of the `Tile`.
     - parameter value:   the `TileValue` to set the `Tile` to
     */
    func setTileValue(value: TileValue) {
        self.value = value
        type = value.checkIfNumberOrOperation()
    }
    
    /**
     Returns the `TileValue` of the `Tile`.
     - returns:   the `TileValue` of the `Tile`
     */
    func getTileValue() -> TileValue {
        return value
    }
    
    /**
     Returns the `TileType` of the `Tile`.
     - returns:   the `TileType` of the `Tile`
     */
    func getTypeType() -> TileType {
        return type
    }
    
    /**
     Returns a `Bool` corresponding to whether the `Tile` is selected or not.
     - returns:   a `Bool` corresponding to whether the `Tile` is selected or not
     */
    func isSelected() -> Bool {
        return selected
    }
    
    /**
     Sets `selected` to `false` and changes the appearance of the `sprite` to signal the state change.
     */
    func selectTile() {
        selected = true
        sprite.color = CCColor(white: 0.5, alpha: 1)
    }
    
    /**
     Sets `selected` to `false` and restores the appearance of the `sprite` to signal the state change.
     */
    func deselectTile() {
        selected = false
        sprite.color = CCColor(white: 1, alpha: 1)
    }
}