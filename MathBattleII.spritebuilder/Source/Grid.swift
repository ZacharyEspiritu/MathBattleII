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
    private var currentlySelectedTiles: [Tile] = []
    
    /**
     Loads 9 new `Tile` instances based on the supplied `[TileValue]` array and displays them on the `Grid`.
     Will crash if the `tileArray` does not contain exactly 9 elements.
     - parameter array:   a `[TileArray]` corresponding to the `Tile` instances to load
     */
    func loadTiles(var array tileArray: [TileValue]) {
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
                
                
                if let oldTile = tiles[rowIndex, columnIndex] {
                    oldTile.zOrder = 1
                    newTile.zOrder = -1
                }
                
                // Add the Tile object as a child of the Grid and add it to the tiles Array2D
                self.addChild(newTile)
                tiles[rowIndex, columnIndex] = newTile
            }
        }
    }
    
    /**
     Returns the `Tile` object at position (`row`, `column`).
     Will crash if no `Tile` exists at (`row`, `column`).
     - parameter row:      the row index of the `Tile` object to return
     - parameter column:   the column index of the `Tile` object to return
     - returns:            the `Tile` object at position (`row`, `column`)
     */
    func getTileAtPosition(row row: Int, column: Int) -> Tile {
        guard let tile = tiles[row, column] else {
            assertionFailure("No Tile exists at (\(row), \(column))")
            return Tile()
        }
        return tile
    }
    
    /**
     Switches the `Tile` object at position (`row`, `column`) to a selected state.
     Will crash if no `Tile` exists at (`row`, `column`).
     - parameter row:      the row index of the `Tile` object to select
     - parameter column:   the column index of the `Tile` object to select
     - returns:            the `Tile` object at position (`row`, `column`)
     */
    func selectTileAtPosition(row row: Int, column: Int) -> Tile {
        guard let tile = tiles[row, column] else {
            assertionFailure("No Tile exists at (\(row), \(column))")
            return Tile()
        }

        currentlySelectedTiles.append(tile)
        tile.selectTile()
        return tile
    }
    
    /**
     Returns a `[Tile]` of all the currently selected tiles on the `Grid`.
     - returns:   a `[Tile]` of all the currently selected tiles on the `Grid`
     */
    func getCurrentlySelectedTiles() -> [Tile] {
        return currentlySelectedTiles
    }
    
    /**
     Switches all of the `Tile` objects in the `Grid` to a deselected state.
     */
    func clearSelectedTiles() {
        for rowIndex in 0..<3 {
            for columnIndex in 0..<3 {
                tiles[rowIndex, columnIndex]!.deselectTile()
            }
        }
        currentlySelectedTiles.removeAll()
    }
    
    /**
     Returns a `[Tile]` of all of the tiles on the `Grid`.
     Use `getCurrentlySelectedTiles()` if you only want the tiles that have been selected (in the order they were selected).
     - returns:   a `[Tile]` of all of the tiles on the `Grid`
     */
    func getAllTilesInGrid() -> [Tile] {
        guard checkIfTilesExistInGrid() else {
            assertionFailure()
            return []
        }
        var tileArray: [Tile] = []
        for rowIndex in 0..<3 {
            for columnIndex in 0..<3 {
                tileArray.append(tiles[rowIndex, columnIndex]!)
            }
        }
        return tileArray
    }
    
    /**
     Permanently removes all of the `Tile` objects on the `Grid` and clears the `Array2D<Tile>`.
     */
    func removeAllTilesInGrid() {
        guard checkIfTilesExistInGrid() else {
            assertionFailure()
            return
        }
        clearSelectedTiles()
        for rowIndex in 0..<3 {
            for columnIndex in 0..<3 {
                tiles[rowIndex, columnIndex]!.removeFromParentAndCleanup(true)
                tiles[rowIndex, columnIndex] = nil
            }
        }
    }
    
    /**
     Checks to see if the `Grid` currently has 9 `Tile` objects loaded.
     - returns:   `true` if the `Grid` currently has 9 `Tile` objects loaded
     */
    private func checkIfTilesExistInGrid() -> Bool {
        for rowIndex in 0..<3 {
            for columnIndex in 0..<3 {
                if tiles[rowIndex, columnIndex] == nil {
                    return false
                }
            }
        }
        return true
    }
}