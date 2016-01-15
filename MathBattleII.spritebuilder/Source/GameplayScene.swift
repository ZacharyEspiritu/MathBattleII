//
//  GameplayScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class GameplayScene: CCNode {
    
    weak var topGrid, bottomGrid: Grid!
    weak var topHUDBar, bottomHUDBar: CCSprite!
    weak var topPlayerDisplay, bottomPlayerDisplay: PlayerDisplay!
    weak var scoreCounterBar: ScoreCounter!
    weak var dividingLine: CCSprite!
    
    var manager = GridManager()
    
    func didLoadFromCCB() {
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        loadNewPuzzle(forSide: .Top)
        loadNewPuzzle(forSide: .Bottom)
    }
    
    func loadNewPuzzle(forSide side: Side) {
        // Generate new puzzle
        let newPuzzle: (Int, String, [TileValue]) = PuzzleGenerator.sharedInstance.generateNewPuzzle()
        let targetNumber: Int = newPuzzle.0
        let sampleEquationSolution: String = newPuzzle.1
        let tileArray: [TileValue] = newPuzzle.2
        
        if side == .Top {
            topGrid.loadTiles(tileArray)
            topPlayerDisplay.setTargetNumberLabel(targetNumber: targetNumber)
        }
        else {
            bottomGrid.loadTiles(tileArray)
            bottomPlayerDisplay.setTargetNumberLabel(targetNumber: targetNumber)
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        let touchLocationInGridOptional: CGPoint?
        
        if touch.locationInWorld().y < CCDirector.sharedDirector().viewSize().height / 2 { // Bottom
            touchLocationInGridOptional = touch.locationInNode(bottomGrid)
            guard let touchLocationInGrid = touchLocationInGridOptional else {
                return
            }
            print(touchLocationInGrid)
            
            let tileCoordinates: (Int, Int) = determinePositionOfTappedTile(touch: touchLocationInGrid, side: Side.Bottom)
            
            bottomGrid.getTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1).color = CCColor(white: 0.5, alpha: 1)
        }
        else { // Top
            touchLocationInGridOptional = touch.locationInNode(topGrid)
            guard let touchLocationInGrid = touchLocationInGridOptional else {
                return
            }
            print(touchLocationInGrid)
            
            let tileCoordinates: (Int, Int) = determinePositionOfTappedTile(touch: touchLocationInGrid, side: Side.Top)
            
            topGrid.getTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1).color = CCColor(white: 0.5, alpha: 1)
        }
        
    }
    
    private func determinePositionOfTappedTile(touch touchLocationInGrid: CGPoint, side: Side) -> (Int, Int) {
        let gridContentSize: CGSize!
        
        switch side {
        case .Top:
            gridContentSize = topGrid.contentSizeInPoints
        case .Bottom:
            gridContentSize = bottomGrid.contentSizeInPoints
        }
        
        var rowIndex: Int!
        if touchLocationInGrid.x < gridContentSize.width / 3 {
            rowIndex = 0
        }
        else if touchLocationInGrid.x < (gridContentSize.width / 3) * 2 {
            rowIndex = 1
        }
        else {
            rowIndex = 2
        }
        
        var columnIndex: Int!
        if touchLocationInGrid.y < gridContentSize.height / 3 {
            columnIndex = 0
        }
        else if touchLocationInGrid.y < (gridContentSize.height / 3) * 2 {
            columnIndex = 1
        }
        else {
            columnIndex = 2
        }
        
        return (rowIndex, columnIndex)
    }
}

enum Side {
    case Top, Bottom
}