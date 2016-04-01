//
//  RankedMatchScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/31/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RankedMatchScene: CCNode {
    
    weak var centerAreaGroupingNode, largeButtonGroupingNode, smallButtonGroupingNode: CCNode!
    weak var largeMenuButton, leftMenuButton, centerMenuButton, rightMenuButton: CCButton!
    weak var newsButton, infoButton, leaderboardButton, gameCenterButton: CCButton!
    
    func didLoadFromCCB() {
        print("loaded scene")
    }
    
    func backToMenu() {
        let gameplayScene = CCBReader.load("MainScene") as! MainScene
        
        let scene = CCScene()
        scene.addChild(gameplayScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
}