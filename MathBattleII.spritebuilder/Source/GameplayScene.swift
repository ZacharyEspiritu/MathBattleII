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
    
    weak var mainDisplay: MainDisplay!
    weak var scoreCounter: ScoreCounter!
    weak var dividingLine: CCSprite!
    
    weak var topSlidingDoor, bottomSlidingDoor: SlidingDoor!
    
    private var gameTimer: GameTimer! = nil
    
    private var topSampleEquationSolution: String! {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(topSampleEquationSolution, forKey: "topSampleEquationSolution")
        }
    }
    private var bottomSampleEquationSolution: String! {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(bottomSampleEquationSolution, forKey: "bottomSampleEquationSolution")
        }
    }
    
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
    
    var multiplayerMatchData: MatchData?
    
    
    // MARK: Functions
    
    /**
     Called when the `GameplayScene` is loaded.
     */
    func didLoadFromCCB() {
        setupGame()
    }
    
    /**
     Prepares the `GameplayScene` for a new game.
     */
    private func setupGame() {
        // Setup multiplayer handling
        multiplayerMatchData = retrieveMatchDataFromMatchmaker()
        multiplayerMatchData?.opposingPlayer.delegate = self
        
        // Clearing stuff just to be safe
        topPlayerDisplay.clearEquationLabel()
        topGrid.clearSelectedTiles()
        bottomPlayerDisplay.clearEquationLabel()
        bottomGrid.clearSelectedTiles()
        
        setupMainDisplay()
        
        // Load new puzzles into play
        if multiplayerMatchData == nil {
            loadNewPuzzle(forSide: .Top)
        }
        loadNewPuzzle(forSide: .Bottom)
        
        setupGameTimer()
        
        // Establish score limits
        scoreCounter.establishScoreLimit(forBothSides: 5)
        
        beginCountdownSequence()
        
        OALSimpleAudio.sharedInstance().playBg("Cuban Sandwich.mp3", volume: 0.2, pan: 0, loop: true)
    }
    
    private func retrieveMatchDataFromMatchmaker() -> MatchData? {
        if let currentMatchData = Matchmaker.sharedInstance.currentMatchData {
            return currentMatchData
        }
        else {
            return nil
        }
    }
    
    /**
     Loads player names from the `UserManager` or displays unknown players as "Guest".
     */
    private func setupMainDisplay() {
        var topDisplayName: String = "Guest"
        if let user = UserManager.sharedInstance.getCurrentUser() {
            topDisplayName = user.getDisplayName()
            if topDisplayName.characters.count > 11 {
                topDisplayName = "\(topDisplayName.substringToIndex(topDisplayName.startIndex.advancedBy(9)))..."
            }
        }
        mainDisplay.setBottomPlayerLabel(string: topDisplayName)
        
        var bottomDisplayName: String = "Guest"
        if let multiplayerMatchData = multiplayerMatchData {
            bottomDisplayName = multiplayerMatchData.opposingPlayer.displayName
            if bottomDisplayName.characters.count > 11 {
                bottomDisplayName = "\(bottomDisplayName.substringToIndex(bottomDisplayName.startIndex.advancedBy(9)))..."
            }
        }
        mainDisplay.setTopPlayerLabel(string: bottomDisplayName)
    }
    
    /**
     Initializes a new `GameTimer` instance and saves it to the `GameplayScene` for future use.
     */
    private func setupGameTimer() {
        gameTimer = GameTimer(gameLengthInSeconds: 90)
        gameTimer.delegate = self
        mainDisplay.updateTimerLabel(timeRemaining: gameTimer.getRemainingTime())
    }
    
    /**
     Begins the countdown sequence to be played before the game begins.
     */
    private func beginCountdownSequence() {
        var countdown: Int = 3
        let slidingDoors: [SlidingDoor] = [topSlidingDoor, bottomSlidingDoor]
        NSTimer.schedule(repeatInterval: 1) { timer in
            if countdown > 0 {
                for slidingDoor in slidingDoors {
                    slidingDoor.label.updateCountdownLabel(string: "\(countdown)")
                }
                countdown--
            }
            else {
                for slidingDoor in slidingDoors {
                    slidingDoor.label.updateCountdownLabel(string: "GO!")
                    slidingDoor.openDoors()
                }
                self.gameTimer.startTimer()
                self.enableUserInteraction()
                OALSimpleAudio.sharedInstance().playEffect("ding.wav")
                OALSimpleAudio.sharedInstance().playEffect("doors.wav")
                timer.invalidate()
            }
        }
    }
    
    /**
     Enables user interaction.
     */
    private func enableUserInteraction() {
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
    }
    
    /**
     Disables user interaction.
     */
    private func disableUserInteraction() {
        self.userInteractionEnabled = false
        self.multipleTouchEnabled = false
    }
    
    /**
     Generates a new puzzle for the specified `Side` and loads it into the `Grid` on that `Side`.
     - parameter forSide:   the `Side` to load a new puzzle in
     */
    private func loadNewPuzzle(forSide side: Side) {
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
            
            // Multiplayer match handling
            if let multiplayerMatchData = multiplayerMatchData {
                multiplayerMatchData.hostPlayer.setCurrentTiles(currentTiles: tileArray)
                multiplayerMatchData.hostPlayer.targetNumber = targetNumber
            }
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
        if CGRectContainsPoint(grid.boundingBox(), locationInNode) { // Tile tapped
            updateTileTappedInGrid(locationInGrid: touch.locationInNode(grid), onSide: sideTouched)
        }
        else {
            let clearButton: CCSprite = (sideTouched == .Top) ? topClearButton : bottomClearButton
            let locationInWorld = touch.locationInNode(self)
            if CGRectContainsPoint(clearButton.boundingBox(), locationInWorld) { // Clear button tapped
                clearCurrentlySelectedTiles(onSide: sideTouched)
                OALSimpleAudio.sharedInstance().playEffect("pop.wav")
            }
            else {
                let equalsButton: CCSprite = (sideTouched == .Top) ? topEqualsButton : bottomEqualsButton
                if CGRectContainsPoint(equalsButton.boundingBox(), locationInWorld) { // Equals button tapped
                    if checkIfRightAnswer(selectedTiles: grid.getCurrentlySelectedTiles(), side: sideTouched) {
                        completePuzzleForSide(side: sideTouched)
                        OALSimpleAudio.sharedInstance().playEffect("ding.wav")
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
            OALSimpleAudio.sharedInstance().playEffect("pop.wav")
            
            // Multiplayer handling code
            if let multiplayerMatchData = multiplayerMatchData {
                multiplayerMatchData.hostPlayer.currentlySelectedTiles.append((tileCoordinates.0 * 3) + tileCoordinates.1)
            }
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
        
        // Multiplayer handling code
        if let multiplayerMatchData = multiplayerMatchData {
            multiplayerMatchData.hostPlayer.currentlySelectedTiles = []
        }
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
            endGame(forReason: .ScoreLimitReached)
        }
        else {
            loadNewPuzzle(forSide: side)
        }
        
        // Multiplayer score update
        if let multiplayerMatchData = multiplayerMatchData {
            multiplayerMatchData.hostPlayer.score = scoreCounter.getBottomScore()
            multiplayerMatchData.hostPlayer.currentlySelectedTiles = []
        }
    }
    
    /**
     Moves all tiles from the `Grid` on the inputted `side` to their respective `launchedTileHolder` to correct drawing order issues, then triggers an animation that launches the `Tile` sprites towards the opposite side in the order they were inputted into the equation.
     - parameter forSide:   the `Side` of the `Grid` to launch the tiles
     */
    private func launchTilesAtOpponent(forSide side: Side) {
        // Setup method variables based on Side input
        let grid: Grid = (side == .Top) ? topGrid : bottomGrid
        let launchedTileHolder: CCNode = (side == .Top) ? topLaunchedTileHolder : bottomLaunchedTileHolder
        let opponentPlayerDisplay: PlayerDisplay = (side == .Top) ? bottomPlayerDisplay : topPlayerDisplay
        
        // Move all tiles from the Grid to the launchedTileHolder to correct draw order
        var tileArray: [Tile] = grid.getCurrentlySelectedTiles()
        for tile in tileArray {
            tile.removeFromParent()
            launchedTileHolder.addChild(tile)
        }
        grid.clearSelectedTiles(andUpdateSpriteFrames: false)
        
        // Launch each Tile in the order it appears in the equation
        var count = 0
        NSTimer.schedule(repeatInterval: 0.15) { timer in
            // Tile launch animation
            let animationDuration: Double = 1.5
            let targetPoint: CGPoint = CGPoint(x: 0.5, y: 3.0)
            let angle = ((CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5) ? -1 : 1) * Float(arc4random_uniform(25) + 255)
            tileArray[count].runAction(CCActionEaseSineIn(action: CCActionRotateBy(duration: animationDuration, angle: angle)))
            tileArray[count].runAction(CCActionEaseBackIn(action: CCActionMoveTo(duration: animationDuration, position: targetPoint)))
            
            // Schedule a timer to shake the Player Display just about when each tile hits the display
            NSTimer.schedule(delay: 1.4) { timer in
                opponentPlayerDisplay.shakeDisplay()
                OALSimpleAudio.sharedInstance().playEffect("pop.wav")
            }
            
            // Check if the last tile has been launched, then schedule a cleanup method to fix everything
            count++
            if count >= 9 {
                timer.invalidate()
                NSTimer.schedule(delay: 2.0) { timer in
                    for child in launchedTileHolder.children {
                        child.removeFromParent()
                    }
                    opponentPlayerDisplay.sneakIntoCorrectPosition()
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
        let grid: Grid = (side == .Top) ? topGrid : bottomGrid
        let playerDisplay: PlayerDisplay = (side == .Top) ? topPlayerDisplay : bottomPlayerDisplay
        
        let count = grid.getCurrentlySelectedTiles().count
        let stringValue = tile.getTileValue().stringValue
        if count == 1 {
            playerDisplay.setEquationLabel(equation: stringValue)
        }
        else if count == 3 || count == 5 || count == 7 {
            playerDisplay.setEquationLabel(equation: "(\(playerDisplay.getEquationLabelString()) \(stringValue))")
        }
        else {
            playerDisplay.setEquationLabel(equation: "\(playerDisplay.getEquationLabelString()) \(stringValue)")
        }
    }
    
    /**
     Checks if the `[Tile]` array is a valid solution for the current puzzle on the `Side`.
     - parameter selectedTiles:   the `[Tile]` array to check
     - parameter side:            the `Side` where the puzzle is stored
     - returns:                   `true` if the answer is a valid solution; `false` otherwise
     */
    private func checkIfRightAnswer(selectedTiles tiles: [Tile], side: Side) -> Bool {
        // Check that all of the tiles have been used
        if tiles.count == 9 {
            // Check that the [TileValue] array is in a valid order of Numbers and Operators
            let tileValues: [TileValue] = convertTilesToTileValues(tiles)
            if checkTileArrayHasCorrectFormat(tileValues) {
                // Calculate the given answer and determine if it matches the targetNumber
                var possibleTargetValue = tileValues[0].rawValue
                for index in 1..<5 {
                    switch tileValues[(index * 2) - 1] {
                    case .Add:
                        possibleTargetValue += tileValues[index * 2].rawValue
                    case .Subtract:
                        possibleTargetValue -= tileValues[index * 2].rawValue
                    case .Multiply:
                        possibleTargetValue *= tileValues[index * 2].rawValue
                    default:
                        assertionFailure()
                    }
                }
                let targetNumber = ((side == .Top) ? topTargetNumber : bottomTargetNumber)
                if possibleTargetValue == targetNumber {
                    return true
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
        // Determine which Grid to use for contentSize. Shouldn't matter, but implemented as a safety precaution.
        let gridContentSize: CGSize = (side == .Top) ? topGrid.contentSizeInPoints : bottomGrid.contentSizeInPoints
        
        // Determine rowIndex
        var rowIndex: Int {
            if touchLocation.x < gridContentSize.width / 3 {
                return 0
            }
            else if touchLocation.x < (gridContentSize.width / 3) * 2 {
                return 1
            }
            else {
                return 2
            }
        }
        
        // Determine columnIndex
        var columnIndex: Int {
            if touchLocation.y < gridContentSize.height / 3 {
                return 0
            }
            else if touchLocation.y < (gridContentSize.height / 3) * 2 {
                return 1
            }
            else {
                return 2
            }
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
    
    /**
     Ends the game with the correct sequence as specified by the `GameStopReason`.
     - parameter forReason:   the `GameStopReason` of why the game should end now
     */
    private func endGame(forReason reason: GameStopReason) {
        // Disable user interaction
        disableUserInteraction()
        
        // Disable gameTimer
        gameTimer?.pauseTimer()
        gameTimer = nil
        
        // Trigger end-game animations
        let slidingDoors: [SlidingDoor] = [topSlidingDoor, bottomSlidingDoor]
        for slidingDoor in slidingDoors {
            if reason == .ScoreLimitReached {
                slidingDoor.label.updateCountdownLabel(string: "END!")
            }
            else {
                slidingDoor.label.updateCountdownLabel(string: "TIME!")
            }
            slidingDoor.closeDoors()
        }
        
        // Play sound effects
        OALSimpleAudio.sharedInstance().stopBg()
        OALSimpleAudio.sharedInstance().playEffect("ding.wav")
        OALSimpleAudio.sharedInstance().playEffect("doors.wav")
        
        // Determine winner and update stats
        let winner: Side? = scoreCounter.getCurrentLeader()
        if let currentUser = UserManager.sharedInstance.getCurrentUser() {
            currentUser.incrementNumberOfGamesPlayed()
            if winner == .Bottom {
                currentUser.incrementNumberOfWins()
            }
            else {
                currentUser.incrementNumberOfLosses()
            }
        }
        
        // Save temporarily to NSUserDefaults for use in next scene
        NSUserDefaults.standardUserDefaults().setInteger(scoreCounter.getTopScore(), forKey: "topScore")
        NSUserDefaults.standardUserDefaults().setInteger(scoreCounter.getBottomScore(), forKey: "bottomScore")
        
        // Transition to EndGameScene
        NSTimer.schedule(delay: 2) { timer in
            let gameplayScene = CCBReader.load("EndGameScene") as! EndGameScene
            
            let scene = CCScene()
            scene.addChild(gameplayScene)
            
            let transition = CCTransition(fadeWithDuration: 0.5)
            CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        }
    }
}

extension GameplayScene: GameTimerDelegate {
    func gameTimerDidUpdate(gameTimer: GameTimer) {
        let timeRemaining = gameTimer.getRemainingTime()
        mainDisplay.updateTimerLabel(timeRemaining: timeRemaining)
        if timeRemaining <= 10 && timeRemaining > 0 {
            OALSimpleAudio.sharedInstance().playEffect("beep.wav", volume: 0.1, pitch: 1, pan: 0, loop: false)
        }
    }
    
    func gameTimerDidFinish(gameTimer: GameTimer) {
        endGame(forReason: .TimeRanOut)
    }
    
    func gameTimerDidPause(gameTimer: GameTimer) {
        print("pause")
    }
    
    func gameTimerDidStart(gameTimer: GameTimer) {
        print("start")
    }
}

extension GameplayScene: PlayerDataDelegate {
    func connectionStatusHasUpdated(playerData: PlayerData) {
        let connectionStatus: Bool = playerData.getConnectionStatus()
        if connectionStatus {
            print("The player has reconnected.")
        }
        else {
            print("The player has disconnected.")
        }
    }
    
    func scoreHasUpdated(playerData: PlayerData) {
        if scoreCounter.setScore(forSide: .Top, newScore: playerData.getScore()) {
            endGame(forReason: .ScoreLimitReached)
        }
    }
    
    func currentTilesHaveUpdated(playerData: PlayerData) {
        print("test")
        if topGrid.checkIfTilesExistInGrid() {
            launchTilesAtOpponent(forSide: .Top)
        }
        topGrid.loadTiles(array: playerData.currentTiles)
    }
    
    func targetNumberHasUpdated(playerData: PlayerData) {
        topTargetNumber = playerData.targetNumber
    }
    
    func currentlySelectedTilesHaveUpdated(playerData: PlayerData) {
        let selectedTiles = playerData.currentlySelectedTiles
        topGrid.clearSelectedTiles()
        for selectedTile in selectedTiles {
            topGrid.selectTileAtPosition(row: Int(floor(Double(selectedTile) / 3)), column: selectedTile % 3)
        }
    }
}

enum Side {
    case Top, Bottom
}

enum GameState {
    case Countdown, Playing, Paused, Endgame
}

enum GameStopReason {
    case ScoreLimitReached, TimeRanOut, ConnectionIssue, Paused
}