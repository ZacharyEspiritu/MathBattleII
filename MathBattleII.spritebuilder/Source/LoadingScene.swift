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
        OALSimpleAudio.sharedInstance().preloadEffect("pop.wav")
        OALSimpleAudio.sharedInstance().preloadEffect("ding.wav")
        OALSimpleAudio.sharedInstance().preloadEffect("flicker.mp3")
    }
    
    func playLoadingSound() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
    
    func playLogoFlickerSound() {
        OALSimpleAudio.sharedInstance().playEffect("flicker.mp3", volume: 0.4, pitch: 1, pan: 0, loop: false)
    }
    
    func playBounceSound() {
        
    }
    
    func playDingSound() {
        OALSimpleAudio.sharedInstance().playEffect("ding.wav")
    }
    
    func segueToMenuScene() {
        let scene = CCScene()
        scene.addChild(CCBReader.load("MainScene") as! MainScene)
        let transition = CCTransition(crossFadeWithDuration: 0.35)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
}