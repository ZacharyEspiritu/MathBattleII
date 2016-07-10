//
//  TestingPopupHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/10/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class TestingPopupHandler {
    
    static var currentTestingPopup: TestingPopup!
    
    // MARK: Visual Functions
    
    static func displayTestingPopup() {
        NSTimer.schedule(delay: 1, handler: { timer in
            self.currentTestingPopup = CCBReader.load("TestingPopup") as! TestingPopup
            self.currentTestingPopup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .TopLeft)
            self.currentTestingPopup.position = CGPoint(x: 0.5, y: 0.5)
            CCDirector.sharedDirector().runningScene.addChild(self.currentTestingPopup)
            OALSimpleAudio.sharedInstance().playEffect("pop.wav")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstGameLoad")
            timer.invalidate()
        })
    }
    
    static func hideTestingPopup() {
        currentTestingPopup.removeFromParent()
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
}