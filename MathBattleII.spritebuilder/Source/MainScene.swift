//
//  MainScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/5/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    weak var centerAreaGroupingNode, menuButtonGroupingNode: CCNode!
    weak var largeMenuButton, leftMenuButton, centerMenuButton, rightMenuButton: CCButton!
    weak var newsButton, infoButton, leaderboardButton, gameCenterButton: CCButton!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    
    /**
     Starts a new instance of the game.
     */
    func play() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        
        let scene = CCScene()
        scene.addChild(CCBReader.load("GameplayScene") as! GameplayScene)
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func segueToUserLoginScene() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        
        let scene = CCScene()
        scene.addChild(CCBReader.load("UserLoginScene") as! UserLoginScene)
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func segueToRankedMatchScene() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        
        let scene = CCScene()
        scene.addChild(CCBReader.load("RankedMatchScene") as! RankedMatchScene)
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func segueToUserRegistrationScene() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")

        let scene = CCScene()
        scene.addChild(CCBReader.load("UserRegistrationScene") as! UserRegistrationScene)
        CCDirector.sharedDirector().presentScene(scene)
    }
}