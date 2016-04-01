//
//  RankedMatchScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/31/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RankedMatchScene: CCNode {
    
    weak var topAreaGroupingNode, centerAreaGroupingNode, largeButtonGroupingNode, smallButtonGroupingNode: CCNode!
    weak var largeMenuButton, leftMenuButton, centerMenuButton, rightMenuButton: CCButton!
    weak var newsButton, infoButton, leaderboardButton, gameCenterButton: CCButton!
    
    weak var levelDisplay: LevelDisplay!
    weak var coinDisplay: CoinDisplay!
    weak var rankingsButton, activityLogButton, achievementsButton, rankedMatchInfoButton: CCButton!
    weak var rankedPlayerHeader: RankedPlayerHeader!
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
            if CGRectContainsPoint(levelDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                levelDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
            else if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                coinDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        levelDisplay.stopAllActions()
        levelDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        coinDisplay.stopAllActions()
        coinDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
    }
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    func backToMenu() {
        let gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
}