//
//  LoadingScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/17/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoadingScene: CCNode {
    
    func didLoadFromCCB() {
        OALSimpleAudio.sharedInstance().preloadEffect(<#T##filePath: String!##String!#>)
        OALSimpleAudio.sharedInstance().preloadEffect("ding.wav")
    }
    
    func playLoadingSound() {
        OALSimpleAudio.sharedInstance().playEffect(<#T##filePath: String!##String!#>)
    }
    
    func segueToMenuScene() {
        OALSimpleAudio.sharedInstance().playEffect("ding.wav")
        
        let scene = CCScene()
        scene.addChild(CCBReader.load("MainScene") as! MainScene)
        CCDirector.sharedDirector().presentScene(scene)
    }
}