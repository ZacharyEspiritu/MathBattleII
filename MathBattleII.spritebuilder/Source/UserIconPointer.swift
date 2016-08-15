//
//  UserIconPointer.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 8/14/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserIconPointer: CCSprite {
    func triggerAnimationSequence() {
        let slideIn = CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: 0, y: 23)))
        let slideUp = CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.18, position: CGPoint(x: 0, y: 17)))
        let slideBack = CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.4, position: CGPoint(x: 0, y: 29)))
        let slideAgain = CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.4, position: CGPoint(x: 0, y: 17)))
        let slideDown = CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: 0, y: 26)))
        let restorePosition = CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.1, position: CGPoint(x: 0, y: 23)))
        let delay = CCActionDelay(duration: 0.52)
        let slideOut = CCActionEaseSineIn(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: -self.contentSize.width, y: 23)))
        
        self.stopAllActions()
        self.runAction(CCActionSequence(array: [slideIn, slideUp, slideBack, slideAgain, slideDown, restorePosition, delay, slideOut]))
    }
}