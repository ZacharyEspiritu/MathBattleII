//
//  ScoreCounter.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ScoreCounter: CCSprite {
    
    weak var topCounter1, topCounter2, topCounter3, topCounter4, middleCounter, bottomCounter1, bottomCounter2, bottomCounter3, bottomCounter4: CCSprite!
    weak var scoreLabel, bottomScoreLabel: CCLabelTTF!
    
    private var topScoreLimit: Int = 5
    private var bottomScoreLimit: Int = 5
    private var topScore: Int = 0 {
        didSet {
            if practiceModeEnabled {
                
            }
            else {
                updateSpriteFrames()
            }
        }
    }
    private var bottomScore: Int = 0 {
        didSet {
            if practiceModeEnabled {
                bottomScoreLabel.string = "\(bottomScore)"
            }
            else {
                updateSpriteFrames()
            }
        }
    }
    
    private let maximumScoreLimit = 5
    private let minimumScoreLimit = 1
    
    var practiceModeEnabled = false
    
    
    func didLoadFromCCB() {
        let scoreLabels = [scoreLabel, bottomScoreLabel]
        for scoreLabel in scoreLabels {
            scoreLabel.visible = false
        }
        bottomScoreLabel.string = "0"
    }
    
    /**
     Determines who is currently winning the game.
     - returns:   the `Side` of the current leader
     */
    func getCurrentLeader() -> Side? {
        var currentLeader: Side? = nil
        if topScore > bottomScore {
            currentLeader = .Top
        }
        else if topScore < bottomScore {
            currentLeader = .Bottom
        }
        return currentLeader
    }
    
    /**
     Returns the score of the top player.
     - returns:   the score of the top player
     */
    func getTopScore() -> Int {
        return topScore
    }
    
    /**
     Returns the score of the bottom player.
     - returns:   the score of the bottom player
     */
    func getBottomScore() -> Int {
        return bottomScore
    }
    
    func enablePracticeMode() {
        practiceModeEnabled = true
        let scoreCounters = [topCounter1, topCounter2, topCounter3, topCounter4, middleCounter, bottomCounter1, bottomCounter2, bottomCounter3, bottomCounter4]
        for scoreCounter in scoreCounters {
            scoreCounter.visible = false
        }
        
        let scoreLabels = [scoreLabel, bottomScoreLabel]
        for scoreLabel in scoreLabels {
            scoreLabel.visible = true
        }
    }
    
    /**
     Establishes the score limit for both sides.
     - parameter forBothSides:   the `scoreLimit` to implement on both sides
     */
    func establishScoreLimit(forBothSides scoreLimit: Int) {
        establishScoreLimit(forTopSide: scoreLimit, forBottomSide: scoreLimit)
    }
    
    /**
     Establishes the score limit for each side indidually.
     Can be used to create a game with a handicap for one of the players.
     - parameter forTopSide:      the `scoreLimit` to implement on the `Top` side
     - parameter forBottomSide:   the `scoreLimit` to implement on the `Bottom` side
     */
    func establishScoreLimit(forTopSide newTopLimit: Int, forBottomSide newBottomLimit: Int) {
        // Check that the new limits are within the allowed range and reduce/increase them if necessary
        topScoreLimit = newTopLimit <= maximumScoreLimit ? (newTopLimit > minimumScoreLimit ? newTopLimit : 1) : maximumScoreLimit
        bottomScoreLimit = newBottomLimit <= maximumScoreLimit ? (newBottomLimit > minimumScoreLimit ? newBottomLimit : 1) : maximumScoreLimit
        
        switch topScoreLimit {
        case 1:
            topCounter1.visible = false
            fallthrough
        case 2:
            topCounter2.visible = false
            fallthrough
        case 3:
            topCounter3.visible = false
            fallthrough
        case 4:
            topCounter4.visible = false
            fallthrough
        case 5:
            break
        default:
            assertionFailure()
        }
        
        switch bottomScoreLimit {
        case 1:
            bottomCounter1.visible = false
            fallthrough
        case 2:
            bottomCounter2.visible = false
            fallthrough
        case 3:
            bottomCounter3.visible = false
            fallthrough
        case 4:
            bottomCounter4.visible = false
            fallthrough
        case 5:
            break
        default:
            assertionFailure()
        }
    }
    
    /**
     Increases the score for the `Side` parameter. 
     Also checks if the new score has reached the `scoreLimit`.
     - parameter forSide:   the `Side` to increase the score
     - returns:             `true` if the new score has reached the `scoreLimit`
     */
    func increaseScore(forSide side: Side) -> Bool {
        switch side {
        case .Top:
            topScore += 1
            if topScore == topScoreLimit {
                if !practiceModeEnabled {
                    return true
                }
            }
        case .Bottom:
            bottomScore += 1
            if bottomScore == bottomScoreLimit {
                if !practiceModeEnabled {
                    return true
                }
            }
        }
        return false
    }
    
    /**
     Sets the score for the `Side` parameter to the specified `newScore`
     Also checks if the new score has reached the `scoreLimit`.
     - parameter forSide:    the `Side` to increase the score
     - parameter newScore:   the new score of the `Side`
     - returns:              `true` if the new score has reached the `scoreLimit`
     */
    func setScore(forSide side: Side, newScore score: Int) -> Bool {
        switch side {
        case .Top:
            topScore = score
            if topScore >= topScoreLimit {
                return true
            }
        case .Bottom:
            bottomScore = score
            if bottomScore >= bottomScoreLimit {
                return true
            }
        }
        return false
    }
    
    /**
     Visually updates the score counters to reflect the current score.
     */
    func updateSpriteFrames() {
        let redColor = CCColor(red: 1, green: 0, blue: 0)
        let blueColor = CCColor(red: 0, green: 0, blue: 1)
        let whiteColor = CCColor(white: 1, alpha: 1)
        
        // Update top side score counter sprite frames
        switch (maximumScoreLimit - topScoreLimit + topScore) {
        case 0:
            topCounter1.color = whiteColor
            topCounter2.color = whiteColor
            topCounter3.color = whiteColor
            topCounter4.color = whiteColor
        case 1:
            topCounter1.color = whiteColor
            topCounter2.color = whiteColor
            topCounter3.color = whiteColor
            topCounter4.color = blueColor
        case 2:
            topCounter1.color = whiteColor
            topCounter2.color = whiteColor
            topCounter3.color = blueColor
            topCounter4.color = blueColor
        case 3:
            topCounter1.color = whiteColor
            topCounter2.color = blueColor
            topCounter3.color = blueColor
            topCounter4.color = blueColor
        case 4:
            topCounter1.color = blueColor
            topCounter2.color = blueColor
            topCounter3.color = blueColor
            topCounter4.color = blueColor
        case 5:
            middleCounter.color = blueColor
        default:
            assertionFailure()
        }
        
        // Update bottom side score counter sprite frames
        switch (maximumScoreLimit - bottomScoreLimit + bottomScore) {
        case 0:
            bottomCounter1.color = whiteColor
            bottomCounter2.color = whiteColor
            bottomCounter3.color = whiteColor
            bottomCounter4.color = whiteColor
        case 1:
            bottomCounter1.color = whiteColor
            bottomCounter2.color = whiteColor
            bottomCounter3.color = whiteColor
            bottomCounter4.color = redColor
        case 2:
            bottomCounter1.color = whiteColor
            bottomCounter2.color = whiteColor
            bottomCounter3.color = redColor
            bottomCounter4.color = redColor
        case 3:
            bottomCounter1.color = whiteColor
            bottomCounter2.color = redColor
            bottomCounter3.color = redColor
            bottomCounter4.color = redColor
        case 4:
            bottomCounter1.color = redColor
            bottomCounter2.color = redColor
            bottomCounter3.color = redColor
            bottomCounter4.color = redColor
        case 5:
            middleCounter.color = redColor
        default:
            assertionFailure()
        }
    }
}