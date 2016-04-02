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
    weak var rankedMatchButtonGroupingNode, playerHeaderGroupingNode: CCNode!
    weak var rankedPlayerHeader: RankedPlayerHeader!
    
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
            if CGRectContainsPoint(levelDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                levelDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
            else if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                coinDisplay.runAction(CCActionScaleTo(duration: 0.05, scale: 0.97))
            }
        }
        else if CGRectContainsPoint(rankedPlayerHeader.boundingBox(), touch.locationInNode(playerHeaderGroupingNode)) {
            rankedPlayerHeader.runAction(CCActionScaleTo(duration: 0.05, scale: 0.95))
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if levelDisplay.scale < 1 {
            if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
                if CGRectContainsPoint(levelDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                    print("touchLevelDisplay")
                }
            }
            levelDisplay.stopAllActions()
            levelDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
        
        if coinDisplay.scale < 1 {
            if CGRectContainsPoint(topAreaGroupingNode.boundingBox(), touch.locationInWorld()) {
                if CGRectContainsPoint(coinDisplay.boundingBox(), touch.locationInNode(topAreaGroupingNode)) {
                    print("touchCoinDisplay")
                }
            }
            coinDisplay.stopAllActions()
            coinDisplay.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
        
        if rankedPlayerHeader.scale < 1 {
            if CGRectContainsPoint(rankedPlayerHeader.boundingBox(), touch.locationInNode(playerHeaderGroupingNode)) {
                segueToUserLoginScene()
            }
            rankedPlayerHeader.stopAllActions()
            rankedPlayerHeader.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
    }
    
    func backToMenu() {
        let gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func battle() {
        let gameplayScene = CCBReader.load("MatchCreate") as! MatchCreate
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func segueToUserLoginScene() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        
        let userRegistrationScene = CCBReader.load("UserLoginScene") as! UserLoginScene
        
        let scene = CCScene()
        scene.addChild(userRegistrationScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
}