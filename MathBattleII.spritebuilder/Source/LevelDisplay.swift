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
    weak var levelMeterCenter, levelMeterRightEnd: CCSprite!
    weak var displayIcon: CCSprite!
    
    weak var levelLabel: CCLabelTTF!
    weak var experienceLabel: CCLabelTTF!
    
    
    func didLoadFromCCB() {
        animateExperienceDisplay()
    }
    
    func animateExperienceDisplay() {
        let meterMaxLength = levelMeterCenter.contentSize.width
        let meterAnimatableLength = meterMaxLength - 10
        let meterCalculatedLength = round(meterAnimatableLength * (135.0 / 200.0)) + 10
        
        levelMeterCenter.scaleX = 0.1
        levelMeterRightEnd.position.x = levelMeterCenter.boundingBox().width
        levelMeterCenter.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.6, scaleX: Float(meterCalculatedLength / meterMaxLength), scaleY: 1.0)))
        levelMeterRightEnd.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.6, position: CGPoint(x: meterCalculatedLength - 0.5, y: levelMeterRightEnd.position.y)))) // Subtract 0.5 to account for half-pixel rendering errors
        
        let experienceLabelWidth = experienceLabel.contentSize.width
        let experienceLabelSpacingConstant: CGFloat = 33
        let experienceLabelMinimumXPosition: CGFloat = 37
        var labelXPosition = CGFloat(meterCalculatedLength - experienceLabelWidth) + experienceLabelSpacingConstant
        if labelXPosition < experienceLabelMinimumXPosition {
            labelXPosition = experienceLabelMinimumXPosition
        }
        
        experienceLabel.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.6, position: CGPoint(x: labelXPosition, y: experienceLabel.position.y))))
    }
}