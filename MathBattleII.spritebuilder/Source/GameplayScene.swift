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
    
    /**
     Called when the `GameplayScene` is loaded.
     */
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
    
    /**
     Generates a new puzzle for the specified `Side` and loads it into the `Grid` on that `Side`.
     - parameter forSide:   the `Side` to load a new puzzle in
     */
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
    
    /**
     Called whenever the screen is tapped.
     This implementation determines which action to take based on the position of the touch on the screen.
     - parameter touch:       the `CCTouch` object of the touch
     - parameter withEvent:   the `CCTouchEvent` that occured due to the touch
     */
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let sideTouched: Side = (touch.locationInWorld().y < CCDirector.sharedDirector().viewSize().height / 2) ? .Bottom : .Top
        let sideGroupingNode: CCNode = (sideTouched == .Top) ? topSide : bottomSide
        let grid: Grid = (sideTouched == .Top) ? topGrid : bottomGrid
        
        let locationInNode = touch.locationInNode(sideGroupingNode)
        if CGRectContainsPoint(grid.boundingBox(), locationInNode) {
            updateTileTappedInGrid(locationInGrid: touch.locationInNode(grid), onSide: sideTouched)
        }
        else {
            let clearButton: CCSprite = (sideTouched == .Top) ? topClearButton : bottomClearButton
            if CGRectContainsPoint(clearButton.boundingBox(), locationInNode) {
                clearCurrentlySelectedTiles(onSide: sideTouched)
            }
            else {
                let equalsButton: CCSprite = (sideTouched == .Top) ? topEqualsButton : bottomEqualsButton
                if CGRectContainsPoint(equalsButton.boundingBox(), locationInNode) {
                    if checkIfRightAnswer(selectedTiles: grid.getCurrentlySelectedTiles(), side: sideTouched) {
                        completePuzzleForSide(side: sideTouched)
                    }
                }
            }
        }
    }
    
    /**
     Determines which `Tile` was tapped in the `Grid` on the specified `Side` and passes it to the `setupEquationLabel(tile:side:)` function.
     **Note:** this function is different from `determinePositionOfTappedTile(touchLocationInGrid:side:)` as the aforementioned function returns a tuple of format `(rowIndex, columnIndex)`. This tuple is used in this function to determine the actual `Tile` object tapped.
     - parameter locationInGrid:   the `CGPoint` location of the tap in the `Grid` node
     - parameter onSide:           the `Side` of the `Grid` where the tap occurred
     */
    private func updateTileTappedInGrid(locationInGrid locationInGrid: CGPoint, onSide side: Side) {
        let grid = (side == .Top) ? topGrid : bottomGrid
        let tileCoordinates: (Int, Int) = determinePositionOfTappedTile(touchLocationInGrid: locationInGrid, side: side)
        let tappedTile = grid.getTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1)
        if !tappedTile.isSelected() {
            setupEquationLabel(tile: grid.selectTileAtPosition(row: tileCoordinates.0, column: tileCoordinates.1), side: side)
        }
    }
    
    /**
     Clears the currently selected tiles on the specified `Side`.
     - parameter onSide:   the `Side` to clear
     */
    private func clearCurrentlySelectedTiles(onSide side: Side) {
        let grid = (side == .Top) ? topGrid : bottomGrid
        grid.clearSelectedTiles()
        
        let playerDisplay = (side == .Top) ? topPlayerDisplay : bottomPlayerDisplay
        playerDisplay.clearEquationLabel()
    }
    
    /**
     Triggers the cleanup sequence when a puzzle is completed.
     It begins the tile launching animation, increases the score on a `Side`, and loads a new puzzle for that `Side`.
     - parameter side:   the `Side` where the puzzle was just completed
     */
    private func completePuzzleForSide(side side: Side) {
        let playerDisplay: PlayerDisplay = (side == .Top) ? topPlayerDisplay : bottomPlayerDisplay
        playerDisplay.clearEquationLabel()
        
        launchTilesAtOpponent(forSide: side)
        
        if scoreCounter.increaseScore(forSide: side) {
            triggerWin(forSide: side)
        }
        else {
            loadNewPuzzle(forSide: side)
        }
    }
    
    /**
     Triggers the win state for a `Side`.
     - parameter forSide:   the `Side` that just won
     */
    private func triggerWin(forSide side: Side) {
        print("win")
    }
    
    /**
     Moves all tiles from the `Grid` on the inputted `side` to their respective `launchedTileHolder` to correct drawing order issues, then triggers an animation that launches the `Tile` sprites towards the opposite side in the order they were inputted into the equation.
     - parameter forSide:   the `Side` of the `Grid` to launch the tiles
     */
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
            let angle = ((CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5) ? -1 : 1) * Float(arc4random_uniform(25) + 255)
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
    
    /**
     Updates the `equationLabel` for the `PlayerDisplay` on the `Side` of the `Tile` input to determine how to update the label.
     Should be used immediately after a `Tile` has been determined to have been pressed.
     - parameter tile:   the `Tile` to use to determine how to update the `equationLabel`
     - parameter side:   the `Side` where the `Tile` is located
     */
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
    
    /**
     Checks if the `[Tile]` array is a valid solution for the current puzzle on the `Side`.
     - parameter selectedTiles:   the `[Tile]` array to check
     - parameter side:            the `Side` where the puzzle is stored
     - returns:                   `true` if the answer is a valid solution; `false` otherwise
     */
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
    
    /**
     Determines the row and column index of the `Tile` in the `Grid` on the `Side` at the location of the specified `touch`.
     - parameter touch:   the location of the touch in the `Grid`
     - parameter side:    the `Side` of the `Grid` where the touch took place
     - returns:           an `(Int, Int)` tuple in the format `(rowIndex, columnIndex)`
     */
    private func determinePositionOfTappedTile(touchLocationInGrid touchLocation: CGPoint, side: Side) -> (Int, Int) {
        // Determine which Grid to use for contentSize. Doesn't matter, but implemented as a safety precaution.
        let gridContentSize: CGSize = (side == .Top) ? topGrid.contentSizeInPoints : bottomGrid.contentSizeInPoints
        
        // Determine rowIndex
        var rowIndex: Int!
        if touchLocation.x < gridContentSize.width / 3 {
            rowIndex = 0
        }
        else if touchLocation.x < (gridContentSize.width / 3) * 2 {
            rowIndex = 1
        }
        else {
            rowIndex = 2
        }
        
        // Determine columnIndex
        var columnIndex: Int!
        if touchLocation.y < gridContentSize.height / 3 {
            columnIndex = 0
        }
        else if touchLocation.y < (gridContentSize.height / 3) * 2 {
            columnIndex = 1
        }
        else {
            columnIndex = 2
        }
        
        return (rowIndex, columnIndex)
    }
    
    /**
     Converts a `[Tile]` array to a `[TileValue]` array of the `TileValues` of the `Tiles` in the input.
     - parameter tiles:   the `[Tile]` array to convert
     - returns:           a `[TileValue]` array of the `TileValues` of the `Tiles` in the input.
     */
    private func convertTilesToTileValues(tiles: [Tile]) -> [TileValue] {
        var tileValues: [TileValue] = []
        for tile in tiles {
            tileValues.append(tile.getTileValue())
        }
        return tileValues
    }
    
    /**
     Checks to see if the `TileValues` in the inputted `[TileValue]` array are in a valid format for equation verification.
     Should be used before using `checkIfRightAnswer` to ensure that no errors occur.
     - parameter tileValues:   the `[TileValue]` array to check
     - returns:                `true` if the `[TileValue]` array has a valid order for equation checking
     */
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