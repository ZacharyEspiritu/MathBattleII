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
        
        let gameplayScene = CCBReader.load("GameplayScene") as! GameplayScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func segueToUserRegistrationScene() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        
        let userRegistrationScene = CCBReader.load("MatchCreate") as! MatchCreate
        
        let scene = CCScene()
        scene.addChild(userRegistrationScene)
        
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
    
    func segueToRankedMatchScene() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        
        let rankedMatchScene = CCBReader.load("RankedMatchScene") as! RankedMatchScene
        let scene = CCScene()
        scene.addChild(rankedMatchScene)
        CCDirector.sharedDirector().presentScene(scene)
    }
}