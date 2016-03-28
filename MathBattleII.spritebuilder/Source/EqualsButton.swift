//
//  EqualsButton.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/27/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class EqualsButton: CCSprite {
    
    /**
     Visually shakes the `EqualsButton` and tints it red temporarily.
     */
    func shakeButton() {
        let position = CGPoint(x: 0, y: 0)
        
        let targetNumberMoveBack = CCActionMoveTo(duration: 0.05, position: CGPoint(x: -10, y: 0))
        let targetNumberMoveForward = CCActionMoveTo(duration: 0.05, position: CGPoint(x: 5, y: 0))
        let targetNumberRestore = CCActionMoveTo(duration: 0.05, position: position)
        
        let tint = CCActionTintTo(duration: 0.1, color: CCColor(red: 1, green: 0, blue: 0))
        let tintRestore = CCActionTintTo(duration: 0.5, color: CCColor(red: 1, green: 1, blue: 1))
        
        self.runAction(CCActionSequence(array: [targetNumberMoveBack, targetNumberMoveForward, targetNumberRestore]))
        self.runAction(CCActionSequence(array: [tint, tintRestore]))
    }
}