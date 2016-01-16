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
    private var topScoreLimit: Int = 5
    private var bottomScoreLimit: Int = 5
    private var topScore: Int = 0 {
        didSet {
            updateSpriteFrames()
        }
    }
    private var bottomScore: Int = 0 {
        didSet {
            updateSpriteFrames()
        }
    }
    
    var delegate: ScoreCounterDelegate?
    
    private let maximumScoreLimit = 5
    private let minimumScoreLimit = 1
    
    func establishScoreLimit(forBothSides scoreLimit: Int) {
        establishScoreLimit(forTopSide: scoreLimit, forBottomSide: scoreLimit)
    }
    
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
    
    func increaseScore(forSide side: Side) -> Bool {
        switch side {
        case .Top:
            topScore++
            if topScore == topScoreLimit {
                return true
            }
        case .Bottom:
            bottomScore++
            if bottomScore == bottomScoreLimit {
                return true
            }
        }
        return false
    }
    
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