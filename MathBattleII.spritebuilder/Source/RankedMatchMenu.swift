//
//  RankedMatchMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RankedMatchMenu: CCNode {
    
    weak var rankingsButton, activityLogButton, achievementsButton, rankedMatchInfoButton: CCButton!
    weak var rankedMatchButtonGroupingNode, playerHeaderGroupingNode: CCNode!
    weak var rankedPlayerHeader: RankedPlayerHeader!
    
    
    func didLoadFromCCB() {
        print("done!")
        userInteractionEnabled = true
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
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        print("test")
        if CGRectContainsPoint(rankedPlayerHeader.boundingBox(), touch.locationInNode(playerHeaderGroupingNode)) {
            rankedPlayerHeader.runAction(CCActionScaleTo(duration: 0.05, scale: 0.95))
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if rankedPlayerHeader.scale < 1 {
            if CGRectContainsPoint(rankedPlayerHeader.boundingBox(), touch.locationInNode(playerHeaderGroupingNode)) {
                segueToUserLoginScene()
            }
            rankedPlayerHeader.stopAllActions()
            rankedPlayerHeader.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
    }
}