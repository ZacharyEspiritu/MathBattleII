//
//  MainScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/5/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    let scrollSpeed: CGFloat = 60
    
    weak var background1, background2: CCSprite!
    var backgrounds: [CCSprite] = []
    
    
    func didLoadFromCCB() {
        backgrounds = [background1, background2]
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
        
        let userRegistrationScene = CCBReader.load("UserRegistrationScene") as! UserRegistrationScene
        
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
    
    override func update(delta: CCTime) {
        for background in backgrounds {
            background.position = CGPoint(x: background.position.x - (scrollSpeed * CGFloat(delta)), y: background.position.y)
            let position = convertToNodeSpace(self.convertToWorldSpace(background.position))
            if position.x <= 0 {
                background.position = CGPoint(x: background.position.x + background.contentSize.width * 2, y: background.position.y)
            }
        }
    }
}