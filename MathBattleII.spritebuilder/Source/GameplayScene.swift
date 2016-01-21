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
    weak var topLaunchedTileHolder, bottomLaunchedTileHolder: CCNode!
    weak var topPlayerDisplay, bottomPlayerDisplay: PlayerDisplay!
    weak var topHUDBar, bottomHUDBar: CCSprite!
    weak var topEqualsButton, bottomEqualsButton: CCSprite!
    weak var topClearButton, bottomClearButton: CCSprite!
    
    weak var countdownDisplay: CountdownDisplay!
    weak var mainDisplay: MainDisplay!
    weak var scoreCounter: ScoreCounter!
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
    
    private var gameState: GameState = .Countdown
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        // Clearing stuff just to be safe
        topPlayerDisplay.clearEquationLabel()
        topGrid.clearSelectedTiles()
        bottomPlayerDisplay.clearEquationLabel()
        bottomGrid.clearSelectedTiles()
        
        loadNewPuzzle(forSide: .Top)
        loadNewPuzzle(forSide: .Bottom)
        
        gameTimer = GameTimer(gameLengthInSeconds: 120)
        gameTimer.delegate = self
        
        mainDisplay.updateTimerLabel(timeRemaining: gameTimer.getRemainingTime())
        
        scoreCounter.establishScoreLimit(forBothSides: 5)
        
        var countdown: Int = 3
        NSTimer.schedule(repeatInterval: 1) { timer in
            if countdown > 0 {
                self.countdownDisplay.updateCountdownLabel(string: "\(countdown)")
                countdown--
            }
            else {
                self.countdownDisplay.updateCountdownLabel(string: "GO!")
                self.countdownDisplay.background.visible = false
                self.gameTimer.startTimer()
                NSTimer.schedule(delay: 0.7) { timer in
                    self.countdownDisplay.removeFromParent()
                    timer.invalidate()
                }
                timer.invalidate()
            }
        }
    }
    
    func loadNewPuzzle(forSide side: Side) {
        // Generate new puzzle and seperate the tuple
        let newPuzzle: (Int, String, [TileValue]) = PuzzleGenerator.sharedInstance.generateNewPuzzle()
        let targetNumber: Int = newPuzzle.0
        let sampleEquationSolution: String = newPuzzle.1
        let tileArray: [TileValue] = newPuzzle.2
        
        // Determine which side to use, display the necessary tiles, then save all of the information
        if side == .Top {
            topGrid.loadTiles(array: tileArray)
            topTargetNumber = targetNumber
            topSampleEquationSolution = sampleEquationSolution
        }
        else {
            bottomGrid.loadTiles(array: tileArray)
            bottomTargetNumber = targetNumber
            bottomSampleEquationSolution = sampleEquationSolution
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if touch.locationInWorld().y < CCDirector.sharedDirector().viewSize().height / 2 { // Touch in bottom half of screen
            if CGRectContainsPoint(bottomGrid.boundingBox(), touch.locationInNode(bottomSide)) {
                let touchLocationInGrid = touch.locationInNode(bottomGrid)
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
                if checkIfRightAnswer(selectedTiles: bottomGrid.getCurrentlySelectedTiles(), side: .Bottom) {
                    completePuzzleForSide(side: .Bottom)
                }
            }
        }
        else { // Touch in top half of screen
            if CGRectContainsPoint(topGrid.boundingBox(), touch.locationInNode(topSide)) {
                let touchLocationInGrid = touch.locationInNode(topGrid)
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
                    completePuzzleForSide(side: .Top)
                }
            }
        }
    }
    
    private func completePuzzleForSide(side side: Side) {
        switch side {
        case .Top:
            launchTilesAtOpponent(forSide: .Top)
            topPlayerDisplay.clearEquationLabel()
            if scoreCounter.increaseScore(forSide: .Top) {
                triggerWin(forSide: .Top)
            }
            else {
                loadNewPuzzle(forSide: .Top)
            }
        case .Bottom:
            launchTilesAtOpponent(forSide: .Bottom)
            bottomPlayerDisplay.clearEquationLabel()
            if scoreCounter.increaseScore(forSide: .Bottom) {
                triggerWin(forSide: .Bottom)
            }
            else {
                loadNewPuzzle(forSide: .Bottom)
            }
        }
    }
    
    private func triggerWin(forSide side: Side) {
        print("win")
    }
    
    private func launchTilesAtOpponent(forSide side: Side) {
        // Move all tiles from the Grid to the launchedTileHolder to correct draw order
        var copiedTileArray: [Tile] = []
        switch side {
        case .Top:
            for tile in topGrid.getCurrentlySelectedTiles() {
                let copiedTile = tile
                tile.removeFromParent()
                topLaunchedTileHolder.addChild(copiedTile)
                copiedTileArray.append(copiedTile)
            }
            topGrid.clearSelectedTiles(andUpdateSpriteFrames: false)
        case .Bottom:
            for tile in bottomGrid.getCurrentlySelectedTiles() {
                let copiedTile = tile
                tile.removeFromParent()
                bottomLaunchedTileHolder.addChild(copiedTile)
                copiedTileArray.append(copiedTile)
            }
            bottomGrid.clearSelectedTiles(andUpdateSpriteFrames: false)
        }
        
        // Launch each tile in the order
        var count = 0
        NSTimer.schedule(repeatInterval: 0.15) { timer in
            // Tile launch animation
            let animationDuration: Double = 1.5
            let targetPoint: CGPoint = CGPoint(x: 0.5, y: 3.0)
            let angle = (CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5 ? -1 : 1) * Float(arc4random_uniform(25) + 255)
            copiedTileArray[count].runAction(CCActionEaseSineIn(action: CCActionRotateBy(duration: animationDuration, angle: angle)))
            copiedTileArray[count].runAction(CCActionEaseBackIn(action: CCActionMoveTo(duration: animationDuration, position: targetPoint)))
            
            // Schedule a timer to shake the Player Display just about when each tile hits the display
            NSTimer.schedule(delay: 1.4) { timer in
                switch side {
                case .Top:
                    self.bottomPlayerDisplay.shakeDisplay()
                case .Bottom:
                    self.topPlayerDisplay.shakeDisplay()
                }
            }
            
            // Check if the last tile has been launched, then schedule a cleanup method to fix everything
            count++
            if count >= 9 {
                timer.invalidate()
                NSTimer.schedule(delay: 2.0) { timer in
                    switch side {
                    case .Top:
                        for child in self.topLaunchedTileHolder.children {
                            child.removeFromParent()
                        }
                        self.bottomPlayerDisplay.sneakIntoCorrectPosition()
                    case .Bottom:
                        for child in self.bottomLaunchedTileHolder.children {
                            child.removeFromParent()
                        }
                        self.topPlayerDisplay.sneakIntoCorrectPosition()
                    }
                }
            }
        }
    }
    
    private func setupEquationLabel(tile tile: Tile, side: Side) {
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
    
    private func checkIfRightAnswer(selectedTiles tiles: [Tile], side: Side) -> Bool {
        if tiles.count == 9 {
            let tileValues = convertTilesToTileValues(tiles)
            if checkTileArrayHasCorrectFormat(tileValues) {
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
        mainDisplay.updateTimerLabel(timeRemaining: gameTimer.getRemainingTime())
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

enum GameState {
    case Countdown, Playing, Paused, Endgame
}