//
//  MainScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/5/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainScene: CCNode {
    
    func didLoadFromCCB() {
        CCDirector.sharedDirector().displayStats = true
    }
    
    /**
     Starts a new instance of the game.
     */
    func play() {
        let gameplayScene = CCBReader.load("GameplayScene") as! GameplayScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
}