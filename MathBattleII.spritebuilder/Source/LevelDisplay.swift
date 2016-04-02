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
    
    var level: Int = 0
    var currentProgress: Int = 0
    var neededExperience: Int = 0
    
    
    func didLoadFromCCB() {
        loadData()
        animateExperienceDisplay()
    }
    
    func loadData() {
        var experienceLevel: Int = 0
        if let user = UserManager.sharedInstance.getCurrentUser() {
            experienceLevel = user.getExperienceLevel()
        }
        
        var levelCount = 0
        var levelExperienceCap = 10
        while experienceLevel > 0 {
            levelCount += 1
            experienceLevel -= 10
            levelExperienceCap = 10
            if levelCount >= 2 {
                experienceLevel -= 25 * (levelCount - 1)
                levelExperienceCap = 25 * (levelCount - 1)
                if levelCount >= 4 {
                    experienceLevel -= 25 * (levelCount - 3)
                    levelExperienceCap += 25 * (levelCount - 3)
                    if levelCount >= 13 {
                        experienceLevel -= 50 * (levelCount - 12)
                        levelExperienceCap += 50 * (levelCount - 12)
                    }
                }
            }
        }
        if experienceLevel < 0 {
            experienceLevel = levelExperienceCap - abs(experienceLevel)
        }
        
        level = levelCount
        currentProgress = experienceLevel
        neededExperience = levelExperienceCap
        
        levelLabel.string = "\(level)"
        experienceLabel.string = "\(currentProgress)/\(neededExperience)"
    }
    
    func animateExperienceDisplay() {
        let meterMaxLength = levelMeterCenter.contentSize.width
        let meterCalculatedLength = round(meterMaxLength * (CGFloat(currentProgress) / CGFloat(neededExperience)))
        
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