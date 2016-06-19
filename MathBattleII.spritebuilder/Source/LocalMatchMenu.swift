//
//  LocalMatchMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/20/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LocalMatchMenu: CCNode {
    
    weak var topMenuButton, bottomMenuButton: CCButton!
    
    func readyButtonPressed() {
        if topMenuButton.selected && bottomMenuButton.selected {
            OALSimpleAudio.sharedInstance().playEffect("pop.wav")
            let scene = CCScene()
            scene.addChild(CCBReader.load("GameplayScene") as! GameplayScene)
            let transition = CCTransition(crossFadeWithDuration: 0.5)
            CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        }
    }
}