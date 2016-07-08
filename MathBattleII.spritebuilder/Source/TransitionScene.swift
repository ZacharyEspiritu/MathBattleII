//
//  TransitionScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/8/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class TransitionScene: CCNode {
    
    weak var background1, background2: CCSprite!
    var backgrounds: [CCSprite] = []
    
    weak var icon: CCSprite!
    
    let viewHeight = CCDirector.sharedDirector().viewSize().height
    let animationConstant: CGFloat = 10
    
    
    // MARK: Animation Functions
    
    func didLoadFromCCB() {
        backgrounds = [background1, background2]
        icon.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        icon.position = CGPoint(x: 0.5, y: -0.5)
        flyInIcon()
    }
    
    private func flyInIcon() {
        icon.stopAllActions()
        icon.runAction(CCActionEaseSineIn(action: CCActionMoveTo(duration: 0.5, position: CGPoint(x: 0.5, y: 0.5))))
    }
    
    private func flyOutIcon() {
        icon.stopAllActions()
        icon.runAction(CCActionEaseSineIn(action: CCActionMoveTo(duration: 0.5, position: CGPoint(x: 0.5, y: 1.5))))
        
    }
    
    override func update(delta: CCTime) {
        for background in backgrounds {
            background.position.y += animationConstant
            if background.position.y > viewHeight {
                background.position.y = -viewHeight
            }
        }
    }
}