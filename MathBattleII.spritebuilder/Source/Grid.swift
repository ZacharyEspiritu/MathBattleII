//
//  Grid.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/7/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Grid: CCNode {
    
    private var tiles = Array2D<Tile>(columns: 3, rows: 3)
    
    private var side: Side!
        
    func didLoadFromCCB() {
        
    }
    
    func loadTiles(var tileArray: [TileValue]) {
        guard tileArray.count == 9 else {
            assertionFailure("loadTiles(tileArray): tileArray did not have exactly 9 TileValue instances")
            return
        }
        for rowIndex in 0..<3 { // Generate each row first
            let rowPosition = Double(rowIndex) * 0.5
            for columnIndex in 0..<3 { // Then generate columns
                let columnPosition = Double(columnIndex) * 0.5
                
                // Create new Tile object:
                let newTile: Tile = CCBReader.load("Tile") as! Tile
                let tileArrayIndex: Int = Int(arc4random_uniform(UInt32(tileArray.count)))
                newTile.setTileValue(tileArray[tileArrayIndex])
                tileArray.removeAtIndex(tileArrayIndex)
                
                // Handle positioning and sizing of the Tile object:
                newTile.contentSizeType = CCSizeType.init(widthUnit: CCSizeUnit.Normalized, heightUnit: CCSizeUnit.Normalized)
                newTile.contentSize = CGSize(width: 0.318, height: 0.331)
                newTile.anchorPoint = CGPoint(x: rowPosition, y: columnPosition)
                newTile.positionType = CCPositionTypeNormalized
                newTile.position = CGPoint(x: rowPosition, y: columnPosition)
                
                // Add the Tile object as a child of the Grid and add it to the tiles Array2D
                self.addChild(newTile)
                tiles[rowIndex, columnIndex] = newTile
            }
        }
    }
}