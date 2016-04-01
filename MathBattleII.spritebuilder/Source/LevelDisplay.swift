//
//  LevelDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/1/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LevelDisplay: CCNode {
    
    weak var background: CCSprite!
    weak var meter: CCSprite9Slice!
    weak var displayIcon: CCSprite!
    
    weak var levelLabel: CCLabelTTF!
    weak var experienceLabel: CCLabelTTF!
    
    
    func didLoadFromCCB() {
        animateExperienceDisplay()
    }
    
    func animateExperienceDisplay() {
        let meterMaxLength = meter.contentSize.width
        let meterAnimatableLength = meterMaxLength - 10
        let meterCalculatedLength = (meterAnimatableLength * (135.0 / 200.0)) + 10
        
        meter.scaleX = 0.1
        meter.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.6, scaleX: Float(meterCalculatedLength / meterMaxLength), scaleY: 1.0)))
    }
    
    func animate() {
        let meterMaxLength = meter.contentSize.width
        let meterAnimatableLength = meterMaxLength - 10
        let meterCalculatedLength = (meterAnimatableLength * (135.0 / 200.0)) + 10
        
        meter.contentSize.width = 10
        NSTimer.schedule(repeatInterval: 0.02, handler: { timer in
            self.meter.contentSize.width += 2
            if self.meter.contentSize.width >= meterCalculatedLength {
                self.meter.contentSize.width = meterCalculatedLength
                timer.invalidate()
            }
        })
    }
}