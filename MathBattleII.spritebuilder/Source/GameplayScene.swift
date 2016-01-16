//
//  GameplayScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class GameplayScene: CCNode {
    
    // MARK: Variables
    
    weak var topSide, bottomSide: CCNode!
    weak var topGrid, bottomGrid: Grid!
    weak var topPlayerDisplay, bottomPlayerDisplay: PlayerDisplay!
    weak var topHUDBar, bottomHUDBar: CCSprite!
    weak var topEqualsButton, bottomEqualsButton: CCSprite!
    weak var topClearButton, bottomClearButton: CCSprite!
    
    weak var mainDisplay: MainDisplay!
    weak var scoreCounterBar: ScoreCounter!
    weak var dividingLine: CCSprite!
    
    private var gameTimer: GameTimer! = nil
    
    private var topSampleEquationSolution, bottomSampleEquationSolution: String!
    private var topTargetNumber: Int! {
        didSet {
            topPlayerDisplay.setTargetNumberLabel(targetNumber: topTargetNumber)
        }
    }
    private var bottomTargetNumber: Int! {
        didSet {
            bottomPlayerDisplay.setTargetNumberLabel(targetNumber: bottomTargetNumber)
        }
    }
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        loadNewPuzzle(forSide: .Top)
        loadNewPuzzle(forSide: .Bottom)
        
        gameTimer = GameTimer(gameLengthInSeconds: 300)
        gameTimer.delegate = self
        gameTimer.startTimer()
    }
    
    func loadNewPuzzle(forSide side: Side) {
        // Generate new puzzle and seperate the tuple
        let newPuzzle: (Int, String, [TileValue]) = PuzzleGenerator.sharedInstance.generateNewPuzzle()
        let targetNumber: Int = newPuzzle.0
        let sampleEquationSolution: String = newPuzzle.1
        let tileArray: [TileValue] = newPuzzle.2
        
        // Determine which side to use, display the necessary tiles, then save all of the information
        if side == .Top {
            topGrid.loadTiles(tileArray)
            topTargetNumber = targetNumber
            topSampleEquationSolution = sampleEquationSolution
        }
        else {
            bottomGrid.loadTiles(tileArray)
            bottomTargetNumber = targetNumber
            bottomSampleEquationSolution = sampleEquationSolution
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        let touchLocationInGridOptional: CGPoint?
        if touch.locationInWorld().y < CCDirector.sharedDirector().viewSize().height / 2 { // Touch in bottom half of screen
            if CGRectContainsPoint(bottomGrid.boundingBox(), touch.locationInNode(bottomSide)) {
                touchLocationInGridOptional = touch.locationInNode(bottomGrid)
                guard let touchLocationInGrid = touchLocationInGridOptional else {
                    return
                }
                print(touchLocationInGrid)
                
                let tileCoordinates: (Int, Int) = determinePositionOfTappedTile(touch: touchLocationInGrid, side: Side.Bottom)
                let tappedTile = bottomGrid.getTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1)
                if !tappedTile.isSelected() {
                    setupEquationLabel(tile: bottomGrid.selectTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1), side: Side.Bottom)
                }
            }
            else if CGRectContainsPoint(bottomClearButton.boundingBox(), touch.locationInNode(bottomSide)) {
                bottomGrid.clearSelectedTiles()
                bottomPlayerDisplay.clearEquationLabel()
            }
            else if CGRectContainsPoint(bottomEqualsButton.boundingBox(), touch.locationInNode(bottomSide)) {
                print("equals")
                if checkIfRightAnswer(selectedTiles: bottomGrid.getCurrentlySelectedTiles(), side: .Bottom) {
                    print("YES")
                }
            }
        }
        else { // Touch in top half of screen
            if CGRectContainsPoint(topGrid.boundingBox(), touch.locationInNode(topSide)) {
                touchLocationInGridOptional = touch.locationInNode(topGrid)
                guard let touchLocationInGrid = touchLocationInGridOptional else {
                    return
                }
                print(touchLocationInGrid)
                
                let tileCoordinates: (Int, Int) = determinePositionOfTappedTile(touch: touchLocationInGrid, side: Side.Top)
                let tappedTile = topGrid.getTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1)
                if !tappedTile.isSelected() {
                    setupEquationLabel(tile: topGrid.selectTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1), side: Side.Top)
                }
            }
            else if CGRectContainsPoint(topClearButton.boundingBox(), touch.locationInNode(topSide)) {
                topGrid.clearSelectedTiles()
                topPlayerDisplay.clearEquationLabel()
            }
            else if CGRectContainsPoint(topEqualsButton.boundingBox(), touch.locationInNode(topSide)) {
                if checkIfRightAnswer(selectedTiles: topGrid.getCurrentlySelectedTiles(), side: .Top) {
                    
                }
            }
        }
    }
    
    func setupEquationLabel(tile tile: Tile, side: Side) {
        switch side {
        case .Top:
            let count = topGrid.getCurrentlySelectedTiles().count
            let stringValue = tile.getTileValue().stringValue
            
            if count == 1 {
                topPlayerDisplay.setEquationLabel(equation: stringValue)
            }
            else if count == 3 || count == 5 || count == 7 {
                topPlayerDisplay.setEquationLabel(equation: "(\(topPlayerDisplay.getEquationLabelString()) \(stringValue))")
            }
            else {
                topPlayerDisplay.setEquationLabel(equation: "\(topPlayerDisplay.getEquationLabelString()) \(stringValue)")
            }
        case .Bottom:
            let count = bottomGrid.getCurrentlySelectedTiles().count
            let stringValue = tile.getTileValue().stringValue
            
            if count == 1 {
                bottomPlayerDisplay.setEquationLabel(equation: stringValue)
            }
            else if count == 3 || count == 5 || count == 7 {
                bottomPlayerDisplay.setEquationLabel(equation: "(\(bottomPlayerDisplay.getEquationLabelString()) \(stringValue))")
            }
            else {
                bottomPlayerDisplay.setEquationLabel(equation: "\(bottomPlayerDisplay.getEquationLabelString()) \(stringValue)")
            }
        }
    }
    
    func checkIfRightAnswer(selectedTiles tiles: [Tile], side: Side) -> Bool {
        if tiles.count == 9 {
            print("count")
            let tileValues = convertTilesToTileValues(tiles)
            if checkTileArrayHasCorrectFormat(tileValues) {
                print("correctformat")
                var possibleTargetValue = tileValues[0].rawValue
                for index in 1..<5 {
                    if tileValues[(index * 2) - 1] == TileValue.add {
                        possibleTargetValue += tileValues[index * 2].rawValue
                    }
                    else if tileValues[(index * 2) - 1] == TileValue.subtract {
                        possibleTargetValue -= tileValues[index * 2].rawValue
                    }
                    else if tileValues[(index * 2) - 1] == TileValue.multiply {
                        possibleTargetValue *= tileValues[index * 2].rawValue
                    }
                    else {
                        assertionFailure()
                    }
                }
                
                switch side {
                case .Top:
                    if possibleTargetValue == topTargetNumber {
                        return true
                    }
                case .Bottom:
                    if possibleTargetValue == bottomTargetNumber {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func determinePositionOfTappedTile(touch touchLocationInGrid: CGPoint, side: Side) -> (Int, Int) {
        // Determine which Grid to use for contentSize. Doesn't matter, but implemented as a safety precaution.
        let gridContentSize: CGSize!
        switch side {
        case .Top:
            gridContentSize = topGrid.contentSizeInPoints
        case .Bottom:
            gridContentSize = bottomGrid.contentSizeInPoints
        }
        
        // Determine rowIndex
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
        
        // Determine columnIndex
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
    
    private func convertTilesToTileValues(tiles: [Tile]) -> [TileValue] {
        var tileValues: [TileValue] = []
        for tile in tiles {
            tileValues.append(tile.getTileValue())
        }
        return tileValues
    }
    
    private func checkTileArrayHasCorrectFormat(tileValues: [TileValue]) -> Bool {
        if tileValues[0].checkIfNumberOrOperation() == TileType.Number &&
            tileValues[1].checkIfNumberOrOperation() == TileType.Operation &&
            tileValues[2].checkIfNumberOrOperation() == TileType.Number &&
            tileValues[3].checkIfNumberOrOperation() == TileType.Operation &&
            tileValues[4].checkIfNumberOrOperation() == TileType.Number &&
            tileValues[5].checkIfNumberOrOperation() == TileType.Operation &&
            tileValues[6].checkIfNumberOrOperation() == TileType.Number &&
            tileValues[7].checkIfNumberOrOperation() == TileType.Operation &&
            tileValues[8].checkIfNumberOrOperation() == TileType.Number {
            return true
        }
        return false
    }
}

extension GameplayScene: GameTimerDelegate {
    
    func gameTimerDidUpdate(gameTimer: GameTimer) {
        let timeRemaining: Int = gameTimer.getRemainingTime()
        let seconds: Int = timeRemaining % 60
        let minutes: Int = (timeRemaining / 60) % 60
        mainDisplay.setTimerLabel(string: String(format: "%02d:%02d", minutes, seconds))
    }
    
    func gameTimerDidFinish(gameTimer: GameTimer) {
        print("finish")
    }
    func gameTimerDidPause(gameTimer: GameTimer) {
        print("pause")
    }
    func gameTimerDidStart(gameTimer: GameTimer) {
        print("start")
    }
}

enum Side {
    case Top, Bottom
}