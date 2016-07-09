//
//  TransitionScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/8/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class TransitionScene: CCNode {
    
    weak var background1, background2, background3: CCSprite!
    var backgrounds: [CCSprite] = []
    
    weak var icon: CCSprite!
    
    let viewHeight = CCDirector.sharedDirector().viewSize().height
    let animationConstant: CGFloat = 70
    
    
    // MARK: Animation Functions
    
    func didLoadFromCCB() {
        backgrounds = [background1, background2, background3]
        icon.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        icon.position = CGPoint(x: 0.5, y: -0.5)
        flyInIcon()
    }
    
    private func flyInIcon() {
        icon.stopAllActions()
        icon.runAction(CCActionSequence(array: [CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.6, position: CGPoint(x: 0.5, y: 0.5))), CCActionDelay(duration: 2.5), CCActionCallFunc(target: self, selector: #selector(self.flyOutIcon))]))
        
    }
    
    @objc private func flyOutIcon() {
        icon.stopAllActions()
        icon.runAction(CCActionSequence(array: [CCActionEaseBackIn(action: CCActionMoveTo(duration: 0.6, position: CGPoint(x: 0.5, y: 1.5))), CCActionCallBlock(block: { TransitionHandler.endTransition() })]))
    }
    
    override func update(delta: CCTime) {
        let scale = CCDirector.sharedDirector().contentScaleFactor
        for background in backgrounds {
            background.position.y += animationConstant * CGFloat(delta)
            background.position.y = round(background.position.y * scale) / scale
            if background.position.y > viewHeight {
                background.position.y = background.position.y - (background.contentSize.height * 3 - 2)
            }
        }
    }
}