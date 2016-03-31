//
//  MainScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/5/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
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
}