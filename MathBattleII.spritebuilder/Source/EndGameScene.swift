//
//  EndGameScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/1/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class EndGameScene: CCNode {
    
    let scrollSpeed: CGFloat = 60
    
    weak var topBackground1, topBackground2: CCSprite!
    weak var bottomBackground1, bottomBackground2: CCSprite!
    var backgrounds: [CCSprite] = []
    
    weak var topMessageLabel, bottomMessageLabel: CCLabelTTF!
    weak var topScoreLabel, bottomScoreLabel: CCLabelTTF!
    weak var topSolutionLabel, bottomSolutionLabel: CCLabelTTF!
    
    weak var topHoldDisplay, bottomHoldDisplay: CCNodeColor!
    
    
    func didLoadFromCCB() {
        backgrounds = [topBackground1, topBackground2, bottomBackground1, bottomBackground2]
        setupLabels()
        setupHoldDisplays()
    }
    
    private func setupLabels() {
        // Load scores from NSUserDefaults
        let topScore = NSUserDefaults.standardUserDefaults().integerForKey("topScore")
        let bottomScore = NSUserDefaults.standardUserDefaults().integerForKey("bottomScore")
        
        // Setup message labels
        if topScore > bottomScore {
            topMessageLabel.string = "WINNER!"
            bottomMessageLabel.string = "LOSER..."
        }
        else if bottomScore > topScore {
            topMessageLabel.string = "LOSER..."
            bottomMessageLabel.string = "WINNER!"
        }
        else {
            topMessageLabel.string = "TIE!"
            bottomMessageLabel.string = "TIE!"
        }
        
        // Setup score labels
        topScoreLabel.string = "SCORE: \(topScore)"
        bottomScoreLabel.string = "SCORE: \(bottomScore)"
        
        // Setup equation solutions
        let topSampleEquationSolution = NSUserDefaults.standardUserDefaults().objectForKey("topSampleEquationSolution") as! String
        let bottomSampleEquationSolution = NSUserDefaults.standardUserDefaults().objectForKey("bottomSampleEquationSolution") as! String
        topSolutionLabel.string = "LAST SOLUTION:\n\(topSampleEquationSolution)"
        bottomSolutionLabel.string = "LAST SOLUTION:\n\(bottomSampleEquationSolution)"
    }
    
    private func setupHoldDisplays() {
        let holdDisplays = [topHoldDisplay, bottomHoldDisplay]
        for holdDisplay in holdDisplays {
            holdDisplay.cascadeOpacityEnabled = true
            holdDisplay.opacity = 0
        }
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
    }
    
    private func returnToMenu() {
        let gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let sideTouched: Side = (touch.locationInWorld().y < CCDirector.sharedDirector().viewSize().height / 2) ? .Bottom : .Top
        let holdDisplay = (sideTouched == .Top) ? topHoldDisplay : bottomHoldDisplay
        holdDisplay.runAction(CCActionFadeTo(duration: 0.6, opacity: 0.8))
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let sideTouched: Side = (touch.locationInWorld().y < CCDirector.sharedDirector().viewSize().height / 2) ? .Bottom : .Top
        let holdDisplay = (sideTouched == .Top) ? topHoldDisplay : bottomHoldDisplay
        holdDisplay.runAction(CCActionFadeTo(duration: 0.6, opacity: 0))
    }
    
    override func update(delta: CCTime) {
        for background in backgrounds {
            background.position = CGPoint(x: background.position.x - (scrollSpeed * CGFloat(delta)), y: background.position.y)
            let position = convertToNodeSpace(self.convertToWorldSpace(background.position))
            if position.x <= 0 {
                background.position = CGPoint(x: background.position.x + background.contentSize.width * 2, y: background.position.y)
            }
        }
        
        if topHoldDisplay.opacity > 0.58 && bottomHoldDisplay.opacity > 0.58 {
            returnToMenu()
        }
    }
}